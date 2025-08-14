package se.seamless.idm.actions.impl

import com.seamless.common.transaction.SystemToken
import groovy.transform.CompileStatic
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import se.seamless.idm.actions.AbstractAction
import se.seamless.idm.enums.LinkActionStatus
import se.seamless.idm.exceptions.ActionProcessingException
import se.seamless.idm.exceptions.FailedAtExternalSystemException
import se.seamless.idm.exceptions.PayloadParsingException
import se.seamless.idm.exceptions.RetriableException
import se.seamless.idm.model.HelperTransaction

import java.util.concurrent.atomic.AtomicBoolean

@CompileStatic
class CimPartnerAction extends AbstractAction
{
    private final static Logger log = LoggerFactory.getLogger(CimPartnerAction.class);

    private final AtomicBoolean initialized = new AtomicBoolean(false)

    private String API_ENDPOINT
    private int RETRY_DELAY_MS
    private String URL_ENDPOINT
    private String AUTH

    @Override
    protected void loadActionData(HelperTransaction transaction) {
        if (!initialized.getAndSet(true)) {
            log.info("Initializing ActionData for ERSPartnerDeboadNotifierAction bean")
            API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-idm-cim-link:15701/cimlink/v1/endpoint")
            RETRY_DELAY_MS = actionDataUtils.getActionDataInteger(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", transaction.getDefaultRetryDelayMs())
            URL_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "URL_ENDPOINT", "http://{{ .Values.HOST__link_simulator }}:{{ .Values.PORT__link_simulator }}/restservice/cim?")
            AUTH = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "AUTH", "bXlncDpPbjEkdHIwN1BhJnM=")

            log.info("Action data loaded: API_ENDPOINT={}, RETRY_DELAY_MS={},URL_ENDPOINT={}",
                    API_ENDPOINT, RETRY_DELAY_MS, URL_ENDPOINT)
        }

        // Always set the transaction retry delay
        transaction.setDefaultRetryDelayMs(RETRY_DELAY_MS)
    }

    @Override
    protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException
    {
        super.evaluatePreConditions(transaction);
        log.debug("No pre-conditions defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
    }

    @Override
    protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException
    {
        log.info(
                "No validation defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
    }

    @Override
    protected void createRequest(HelperTransaction transaction) throws ActionProcessingException
    {
        log.info(
                "Started creation of request for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
        try
        {
            SystemToken systemToken = commonUtils.getSystemToken(transaction.getInboundRequest().getToken());
            Map<String, Object> jsonRequestMap = new HashMap<>();
            actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "referenceId", systemToken.getErsReference(), true, "");

            String operationType = transformToChangeType(transaction.getInboundRequest().getOperationType());

            String action = transformToAction(operationType);
            actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "action", action, true, "");

            getResources(jsonRequestMap,transaction.getInboundRequest().getPayload());

            String jsonRequest = commonUtils.parseJson(jsonRequestMap);
            log.debug("Created JSON request: {}", jsonRequest);

            transaction.getLinkActionInProgress().setRequest(jsonRequest);
        }
        catch (Exception e)
        {
            log.error("Failed to create JSON request", e);
            throw new ActionProcessingException("Failed to create JSON request: " + e.getMessage());
        }
    }

    @Override
    protected void makeApiCall(HelperTransaction transaction) throws RetriableException
    {
        String jsonRequest = transaction.getLinkActionInProgress().getRequest();
        HttpEntity<String> requestEntity = buildHttpEntity(jsonRequest,transaction.getInboundRequest().getToken());

        try
        {
            String response = restTemplate.postForObject(API_ENDPOINT, requestEntity, String.class);
            transaction.getLinkActionInProgress().setResponse(response);
        }
        catch (Exception e)
        {
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL);
            log.error("Failed to make API call", e);
            throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL);
        }
    }

    @Override
    protected void handleResponse(HelperTransaction transaction)
            throws ActionProcessingException, FailedAtExternalSystemException, PayloadParsingException, RetriableException
    {
        //Throw RetryableException if we want to retry the API call
        if (Objects.isNull(transaction.getLinkActionInProgress().getResponse()))
        {
            log.error("NULL response from Cim");
            throw new FailedAtExternalSystemException("NULL response from Cim");
        }
        Map<String, Object> responseMap = commonUtils.convertObjectToMap(transaction.getLinkActionInProgress().getResponse());
        if (!responseMap.containsKey("status"))
        {
            log.error("Invalid response from Cim: {}", responseMap);
            throw new ActionProcessingException("Invalid response from Cim: " + responseMap);
        }

        Map<String, Object> actionDataMap = transaction.getActionResponseData().get(transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy());
        actionDataMap.put("status", responseMap.get("status"));
        actionDataMap.put("message", responseMap.get("message"));

    }

    @Override
    protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException
    {
        String action = transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy();
        Map<String, Object> actionDataMap = transaction.getActionResponseData().get(action);
        if (Objects.isNull(actionDataMap))
        {
            log.error("No action data map found for action: {}", action);
            throw new ActionProcessingException("No action data map found for action: " + action);
        }
        log.debug("Extracted action data map: {}", actionDataMap);
    }

    @Override
    protected void callback(HelperTransaction transaction) throws ActionProcessingException
    {
        log.debug(
                "No callback defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
    }

    private void getResources(Map<String, Object> jsonRequestMap,String payload) throws ActionProcessingException, PayloadParsingException
    {
        if (Objects.isNull(payload))
            throw new PayloadParsingException("Payload can NOT be NULL");

        Map<String, String> request = new HashMap<>();
        //Get the partnerCode/resellerId from JSON payload
        Map<String, Object> payloadData = commonUtils.convertObjectToMap(payload);
        Map<String, Object> extraFields = commonUtils.convertObjectToMap(payloadData.get("extraFields"));
        Map<String, Object> dynamicData = commonUtils.convertObjectToMap(payloadData.get("dynamicData"));
        if(payloadData.get("roleId") != null && !payloadData.get("roleId").toString().isBlank() ){
            actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "msisdn", payloadData.get("msisdn").toString(), true, "");
            actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "nid", payloadData.get("nationalIdNumber").toString(), true, "");
        }else if(payloadData.get("roleId") == null &&  payloadData.get("customerType")!=null){
            if(payloadData.get("customerType").equals("SE") || payloadData.get("customerType").equals("GPCF")) {
                actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "msisdn", extraFields.get("ersMsisdn").toString(), true, "");
                actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "nid", payloadData.get("nationalIdNumber").toString(), true, "");
            } else{
                if(payloadData.get("customerType").equals("RET")){
                    List<Map<String, Object>> posList = (List<Map<String, Object>>) dynamicData.partnerProperties;
                    if(posList.any { Map<String, Object> pos -> pos.partnerType == "MFS"}) {
                        actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "msisdn", extraFields.get("mfsMsisdn").toString(), true, "");
                    } else {
                        actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "msisdn", extraFields.get("ersMsisdn").toString(), true, "");
                    }
                }
                actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "nid", dynamicData.get("nidNumber").toString(), true, "");
            }
        } else {
            actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "msisdn", payloadData.get("msisdn").toString(), true, "");
        }
        actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "dob", payloadData.get("dateOfBirth").toString(), true, "");
    }


    private static String transformToChangeType(String operationType) throws ActionProcessingException
    {
        switch (operationType)
        {
            case "RESELLER_ONBOARD_CIM_VALIDATION":
                return "CREATED";
            case "RESELLER_MODIFY":
                return "UPDATED";
            case "RESELLER_SUSPEND":
                return "SUSPENDED";
            case "RESELLER_DEBOARD":
                return "DELETED";
            default:
                throw new ActionProcessingException("Invalid operation type: " + operationType);
        }
    }

    private static String transformToAction(String operationType) throws ActionProcessingException
    {
        switch (operationType)
        {
            case "CREATED":
                return "ERSO";
            case "DELETED":
                return "ERSD";
            default:
                throw new ActionProcessingException("Invalid operation type: " + operationType+" for action");
        }
    }

    private HttpEntity<String> buildHttpEntity(String jsonRequest,String systemToken) {

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("system-token", systemToken);
        HttpEntity<String> requestEntity = new HttpEntity<>(jsonRequest,headers);
        return requestEntity;
    }
}