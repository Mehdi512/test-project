package se.seamless.idm.actions.impl

import groovy.transform.CompileStatic
import groovy.transform.Immutable

import java.util.ArrayList
import java.util.Arrays
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.Objects
import java.util.concurrent.atomic.AtomicBoolean
import java.util.stream.Collectors

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.w3c.dom.Document
import org.w3c.dom.Element

import se.seamless.idm.actions.AbstractAction
import se.seamless.idm.enums.LinkActionStatus
import se.seamless.idm.exceptions.ActionProcessingException
import se.seamless.idm.exceptions.FailedAtExternalSystemException
import se.seamless.idm.exceptions.RetriableException
import se.seamless.idm.exceptions.SkippableActionException
import se.seamless.idm.model.HelperTransaction

@CompileStatic
class ERSPartnerOnboardAndModifyCentralCallbackAction extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(ERSPartnerOnboardAndModifyCentralCallbackAction.class);

    private final AtomicBoolean initialized = new AtomicBoolean(false);
    private final Map<String, Object> callbackData = new HashMap<>();

    private String RESPONSE_USER_ID;
    private String ERS_CALLBACK_ORIGIN_ID;
    private String ERS_CALLBACK_API_ENDPOINT;
    private String STATUS_CODE;
    private String MESSAGE;
    private List<String> RETRIABLE_STATUS_CODES;
    private int RETRY_DELAY_MS;

    @Override
    protected void loadActionData(HelperTransaction transaction) {
        log.debug("Loading action data for ERSPartnerOnboardAndModifyCentralCallbackAction");
        if (!initialized.getAndSet(true)) {
            log.info("Initializing ActionData for ERSPartnerOnboardAndModifyCentralCallbackAction bean");
            RESPONSE_USER_ID = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_USER_ID", "USERID");
            ERS_CALLBACK_ORIGIN_ID = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "ERS_CALLBACK_ORIGIN_ID", "originId");
            ERS_CALLBACK_API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "ERS_CALLBACK_API_ENDPOINT", "http://svc-dealer-management:8033/dms/auth/updateReseller");
            STATUS_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "STATUS_CODE", "resultCode");
            MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "MESSAGE", "resultDescription");
            RETRIABLE_STATUS_CODES = actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "RETRIABLE_STATUS_CODES", Arrays.asList("500", "502", "503", "504"));
            RETRY_DELAY_MS = actionDataUtils.getActionDataInteger(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", 1000);
            log.info("Action data loaded: RESPONSE_USER_ID={}, ERS_CALLBACK_ORIGIN_ID={}, ERS_CALLBACK_API_ENDPOINT={}, STATUS_CODE={}, MESSAGE={}, RETRIABLE_STATUS_CODES={}, RETRY_DELAY_MS={}", 
                    RESPONSE_USER_ID, ERS_CALLBACK_ORIGIN_ID, ERS_CALLBACK_API_ENDPOINT, STATUS_CODE, MESSAGE, RETRIABLE_STATUS_CODES, RETRY_DELAY_MS);
        }
        // Always set the transaction retry delay
        transaction.setDefaultRetryDelayMs(RETRY_DELAY_MS);
    }

    @Override
    protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException, SkippableActionException {
        log.debug("Evaluating pre-conditions for ERSPartnerOnboardAndModifyCentralCallbackAction");
        super.evaluatePreConditions(transaction);
        Map<String, Object> successActionResponse = new HashMap<>();
        
        for (def action : transaction.getLinkActions()) {
            if (action.getStatus() == LinkActionStatus.SUCCESS) {
                successActionResponse.put(action.getActionRule().getAction().getGroovy(), action.getResponse());
            }
        }

        if(successActionResponse.isEmpty()) {
            throw new SkippableActionException("No dependent success actions found for callback", LinkActionStatus.SKIPPED);
        }

        for(Map.Entry<String, Object> entry : successActionResponse.entrySet()) {
            String actionName = entry.getKey();
            Object actionResponse = entry.getValue();

            if(commonUtils.isValidJson(actionResponse)) {
                handleJsonResponse(actionName, actionResponse);
            } else if(commonUtils.isValidXml(actionResponse)) {
                handleXmlResponse(actionName, actionResponse);
            } else {
                throw new ActionProcessingException("Invalid action response to proceed with callback, actionName: " + actionName);
            }
        }
    }       

    @Override
    protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.debug("Validating request for ERSPartnerOnboardAndModifyCentralCallbackAction");
        if(Objects.isNull(transaction.getInboundRequest().getPayload()) 
                || transaction.getInboundRequest().getPayload().isEmpty())
        {
            log.error("No payload found in inbound request");
            throw new ActionProcessingException("No payload found in inbound request");
        }

        if(callbackData.isEmpty() || 
            !callbackData.containsKey(RESPONSE_USER_ID)) {
            throw new ActionProcessingException(String.format("No callback data %s found", callbackData));
        }
        if(callbackData.get(RESPONSE_USER_ID) == null) {
            throw new ActionProcessingException(String.format("Invalid user id %s found in callback data", callbackData.get(RESPONSE_USER_ID)));
        }
    }

    @Override
    protected void createRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.debug("Creating request for ERSPartnerOnboardAndModifyCentralCallbackAction");
        Map<String, Object> payloadMap = commonUtils.convertObjectToMap(transaction.getInboundRequest().getPayload());

        if(!payloadMap.containsKey("reseller") || Objects.isNull(payloadMap.get("reseller")))
        {
            log.error("No reseller found in inbound request");
            throw new ActionProcessingException("No reseller found in inbound request");
        }
        Map<String, Object> reseller = commonUtils.convertObjectToMap(payloadMap.get("reseller"));

        Map<String, Object> request = new HashMap<>();
        Map<String, Object> dealerData = getDealerData(transaction, reseller);
        Map<String, Object> dealerPrincipal = getDealerPrincipal(transaction, reseller);
        request.put("dealerData", dealerData);
        request.put("dealerPrincipal", dealerPrincipal);

        transaction.getLinkActionInProgress().setRequest(commonUtils.parseJson(request));
    }
        
    @Override
    protected void makeApiCall(HelperTransaction transaction) throws RetriableException {
        log.debug("Making API call for ERSPartnerOnboardAndModifyCentralCallbackAction");
        String request = transaction.getLinkActionInProgress().getRequest();
        HttpEntity<String> requestEntity = buildHttpEntity(request, transaction);
        try {
            String response = restTemplate.postForObject(constructAPIEndpoint(), requestEntity, String.class);
            transaction.getLinkActionInProgress().setResponse(response);
            log.debug("Received response: {}", response);
        }
        catch (Exception e) {
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL);
            log.error("Failed to make API call", e);
            throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL);
        }
    }

    private HttpEntity<String> buildHttpEntity(String request, HelperTransaction helperTransaction) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("system-token", helperTransaction.getInboundRequest().getToken());
        headers.set("authorization", helperTransaction.getInboundRequest().getAuthorization());
        return new HttpEntity<>(request, headers);
    }
    
    @Override
    protected void handleResponse(HelperTransaction transaction) throws ActionProcessingException, FailedAtExternalSystemException, RetriableException {
        log.debug("Handling response for ERSPartnerOnboardAndModifyCentralCallbackAction");
        if (Objects.isNull(transaction.getLinkActionInProgress().getResponse()) || transaction.getLinkActionInProgress().getResponse().isEmpty()) {
            log.error("NULL or empty response from DMS");
            throw new FailedAtExternalSystemException("NULL or empty response from DMS");
        }
        Map<String, Object> responseMap = commonUtils.convertObjectToMap(transaction.getLinkActionInProgress().getResponse());
        if (!responseMap.containsKey(STATUS_CODE)) {
            log.error("Invalid response from DMS: {}", responseMap);
            throw new ActionProcessingException("Invalid response from DMS: " + responseMap);
        }

        Map<String, Object> actionDataMap = transaction.getActionResponseData().get(transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy());
        actionDataMap.put(STATUS_CODE, responseMap.get(STATUS_CODE));
        actionDataMap.put(MESSAGE, responseMap.get(MESSAGE));
        Integer statusCode = (Integer) responseMap.get(STATUS_CODE);

        if (RETRIABLE_STATUS_CODES.contains(responseMap.get(STATUS_CODE).toString())) {
            String errorMessage = responseMap.containsKey(MESSAGE) ? responseMap.get(MESSAGE).toString() : "Unknown error";
            log.debug("Response from DMS: {}", errorMessage);
            log.error("Retriable status code from DMS: {}", statusCode);
            throw new RetriableException(errorMessage, LinkActionStatus.FAILED_AT_EXTERNAL_SYSTEM);
        }

        if (statusCode != 0) {
            log.error("Failed to update reseller data in DMS with id: {}", transaction.getDynamicData().get("resellerId"));
            throw new FailedAtExternalSystemException("Failed to update reseller data in DMS with id: " + responseMap.get("message"));
        }
    }

    @Override
    protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
        log.debug("No response data to extract for ERSPartnerOnboardAndModifyCentralCallbackAction");
    }

    @Override
    protected void callback(HelperTransaction transaction) throws ActionProcessingException {
        log.debug("Callback not defined for ERSPartnerOnboardAndModifyCentralCallbackAction");
    }

    private void handleJsonResponse(String actionName, Object actionResponse) throws ActionProcessingException  {
        log.debug("Handling JSON response for action: {}", actionName);
    }

    private void handleXmlResponse(String actionName, Object actionResponse) throws ActionProcessingException {
        log.debug("Handling XML response for action: {}", actionName);

        switch (actionName) {
            case "ERSPartnerOnboardAndModifyAction":
                handleERSPartnerOnboardAndModifyXmlResponse(actionResponse);
                break;
            default:
                break;
        }
    }

    private void handleERSPartnerOnboardAndModifyXmlResponse(Object actionResponse) throws ActionProcessingException {
        log.debug("Handling ERSPartnerOnboardAndModify XML response");
        try {
            // Parse the XML response
            Document doc = commonUtils.parseXml(actionResponse.toString());
            Element rootElement = doc.getDocumentElement();
            String userId = rootElement.getElementsByTagName(RESPONSE_USER_ID).item(0).getTextContent();
            callbackData.put(RESPONSE_USER_ID, userId);
        } catch (Exception e) {
            log.error("Error parsing ERSPartnerOnboardAndModify XML response", e);
            throw new ActionProcessingException("Error parsing ERSPartnerOnboardAndModify XML response");
        }
    }

    private Map<String, Object> getDealerData(HelperTransaction transaction, Map<String, Object> resellerMap) throws ActionProcessingException {
        Map<String, Object> dealerDataMap = new HashMap<>();
        Map<String, Object> resellerData = new HashMap<>();
        List<AdditionalData> additionalDataList = new ArrayList<>();

        if(!resellerMap.containsKey("resellerTypeId") || Objects.isNull(resellerMap.get("resellerTypeId")) || resellerMap.get("resellerTypeId").toString().isEmpty())
        {
            log.error("No reseller type id found in inbound request");
            throw new ActionProcessingException("No reseller type id found in inbound request");
        }
        
        String resellerTypeId = resellerMap.get("resellerTypeId").toString();
        resellerData.put("resellerTypeId", resellerTypeId);
    
        AdditionalData additionalData = new AdditionalData("originId", callbackData.get(RESPONSE_USER_ID).toString());
        additionalDataList.add(additionalData);

        dealerDataMap.put("resellerData", resellerData);
        dealerDataMap.put("additionalFields", additionalDataList);
        return dealerDataMap;
    }

    private Map<String, Object> getDealerPrincipal(HelperTransaction transaction, Map<String, Object> resellerMap) throws ActionProcessingException {
        Map<String, Object> dealerPrincipal = new HashMap<>();
        if(!resellerMap.containsKey("resellerId") || Objects.isNull(resellerMap.get("resellerId")) || resellerMap.get("resellerId").toString().isEmpty())
        {
            log.error("No reseller id found in inbound request");
            throw new ActionProcessingException("No reseler id found in inbound request");
        }
        String dealerId = resellerMap.get("resellerId").toString();
        transaction.getDynamicData().put("resellerId", dealerId);
        dealerPrincipal.put("id", dealerId);
        dealerPrincipal.put("type", "RESELLERID");
        return dealerPrincipal;
    }

    @Immutable
    static class AdditionalData {
        final String name;
        final String value;
    }   

    private String constructAPIEndpoint() {
        String API = ERS_CALLBACK_API_ENDPOINT + "?client=" + "HELPER-LINK";
        return API;
    }
} 