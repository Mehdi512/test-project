package se.seamless.idm.actions.impl

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.springframework.web.client.HttpClientErrorException
import groovy.transform.CompileStatic
import com.seamless.common.transaction.SystemToken

import se.seamless.idm.actions.AbstractAction
import se.seamless.idm.enums.LinkActionStatus
import se.seamless.idm.exceptions.ActionProcessingException
import se.seamless.idm.exceptions.FailedAtExternalSystemException
import se.seamless.idm.exceptions.PayloadParsingException
import se.seamless.idm.exceptions.RetriableException
import se.seamless.idm.model.HelperTransaction
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.core.type.TypeReference

import java.util.Arrays
import java.util.HashMap
import java.util.HashSet
import java.util.Map
import java.util.Objects
import java.util.Set

import se.seamless.idm.exceptions.SkippableActionException
import se.seamless.idm.enums.LinkActionStatus

import java.util.concurrent.atomic.AtomicBoolean

@CompileStatic
class CockpitProductBulkDataAddNotifierAction extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(CockpitProductBulkDataAddNotifierAction.class)

    private final AtomicBoolean initialized = new AtomicBoolean(false);

    private String API_ENDPOINT;
    private String RETRY_DELAY_MS;
    private String STATUS_CODE;
    private String MESSAGE;
    private List<String> RETRIABLE_STATUS_CODES;
    private boolean LIMIT_DYNAMIC_DATA;

    @Override
    protected void loadActionData(HelperTransaction transaction) {
        if (!initialized.getAndSet(true)) {
            log.info("Loading action data for CockpitProductBulkDataAddNotifierAction, requestId: {}", transaction.getInboundRequest().getId());
            API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-idm-cockpit-link:15501/cockpitlink/v1/endpoint");
            RETRY_DELAY_MS = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", "1000");
            STATUS_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "STATUS_CODE", "resultCode");
            MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "MESSAGE", "message");
            LIMIT_DYNAMIC_DATA = actionDataUtils.getActionDataBoolean(transaction.getLinkActionInProgress(), "LIMIT_DYNAMIC_DATA", true);
            RETRIABLE_STATUS_CODES = actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "RETRIABLE_STATUS_CODES", Arrays.asList("500", "400"));
            log.info("Action data loaded: API_ENDPOINT={}, RETRY_DELAY_MS={}, STATUS_CODE={}, MESSAGE={}, RETRIABLE_STATUS_CODES={}",
                    API_ENDPOINT, RETRY_DELAY_MS, STATUS_CODE, MESSAGE, RETRIABLE_STATUS_CODES);
        }
        transaction.setDefaultRetryDelayMs(Integer.parseInt(RETRY_DELAY_MS));
    }

    @Override
    protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException, SkippableActionException {
        log.debug("Checking pre-conditions defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())

        List<String> addedProductCodes = getResourceIds(transaction.getInboundRequest().getPayload(), transaction.getInboundRequest().getOperationType())
        if (addedProductCodes == null || addedProductCodes.isEmpty()) {
            throw new SkippableActionException("Skipped due to empty add products list", LinkActionStatus.SKIPPED)
        }

    }

    @Override
    protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException, SkippableActionException {
        log.info("No validation defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
    }

    @Override
    protected void createRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Started creation of request for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            String jsonRequest = createJsonRequestString(transaction.getInboundRequest().getPayload(),
                                              commonUtils.getSystemToken(transaction.getInboundRequest().getToken()), transaction)
            transaction.getLinkActionInProgress().setRequest(jsonRequest)
            log.debug("Created JSON request: {}", jsonRequest)
        } catch (Exception e) {
            log.error("Failed to create JSON request", e)
            throw new ActionProcessingException("Failed to create JSON request: " + e.getMessage())
        }
    }

    @Override
    protected void makeApiCall(HelperTransaction transaction) throws RetriableException {
        String jsonRequest = transaction.getLinkActionInProgress().getRequest()
        HttpEntity<String> requestEntity = buildHttpEntity(jsonRequest, transaction.getInboundRequest().getToken())

        try {
            String response = restTemplate.postForObject(API_ENDPOINT, requestEntity, String.class)
            transaction.getLinkActionInProgress().setResponse(response)
        } catch (HttpClientErrorException.BadRequest e) {
            log.error("Failed to make API call", e)
            throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL)
        }
    }

    @Override
    protected void handleResponse(HelperTransaction transaction) throws ActionProcessingException, FailedAtExternalSystemException, PayloadParsingException, RetriableException {
        if(Objects.isNull(transaction.getLinkActionInProgress().getResponse())) {
            log.error("NULL response from Cockpit")
            throw new FailedAtExternalSystemException("NULL response from Cockpit")
        }
        Map<String, Object> responseMap = commonUtils.convertObjectToMap(transaction.getLinkActionInProgress().getResponse())
        if(!responseMap.containsKey(STATUS_CODE)) {
            log.error("Invalid response from Cockpit: {}", responseMap)
            throw new ActionProcessingException("Invalid response from Cockpit: " + responseMap)
        }

        Map<String, Object> actionDataMap = transaction.getActionResponseData().get(transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy())
        actionDataMap.put(STATUS_CODE, responseMap.get(STATUS_CODE))
        actionDataMap.put(MESSAGE, responseMap.get(MESSAGE))
        Integer statusCode = (Integer) responseMap.get(STATUS_CODE)

        if(RETRIABLE_STATUS_CODES.contains(responseMap.get(STATUS_CODE))) {
            log.debug("Response from Cockpit: {}", responseMap.get(MESSAGE))
            log.error("Retriable status code from Cockpit: {}", statusCode)
            throw new RetriableException(responseMap.get(MESSAGE).toString(), LinkActionStatus.FAILED_AT_HANDLE_RESPONSE)
        }

        if(statusCode != 0) {
            log.error("Failed to update region data in Cockpit: {}", responseMap.get(MESSAGE))
            throw new FailedAtExternalSystemException("Failed to update region data in Cockpit: " + responseMap.get(MESSAGE))
        }
    }

    @Override
    protected void callback(HelperTransaction transaction) throws ActionProcessingException {
        log.debug("No callback defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
    }

    private String createJsonRequestString(String payload, SystemToken systemToken, HelperTransaction transaction) throws ActionProcessingException {
        Map<String, Object> jsonRequestMap = new HashMap<>()
        jsonRequestMap.put("transactionId", systemToken.getErsReference())
        actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "transactionId", systemToken.getErsReference())
        actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "infoType", "PRODUCT_ATTRIBUTE")
        actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "changeType", transformToChangeType(transaction.getInboundRequest().getOperationType()))
        addResourceIds(jsonRequestMap, transaction.getInboundRequest().getOperationType(), payload)
        actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "metaData", new Object())
        return commonUtils.parseJson(jsonRequestMap)
    }

    private void addResourceIds(Map<String, Object> jsonRequestMap, String operationType, String payload){

        List<String> resourceIdList = new ArrayList<>();
        List<String> addedProductCodes = getResourceIds(payload, operationType)
        log.debug("Added product codes : {} ", addedProductCodes)
        if (addedProductCodes) {
            resourceIdList.addAll(addedProductCodes)
        }
        actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "resourceIds", resourceIdList)
    }

    private List<String> getResourceIds(String payload, String operationType){
        Map<String, Object> payloadMap = commonUtils.convertObjectToMap(payload.toString())
        if("ADD_BULK_PRODUCT".equalsIgnoreCase(operationType))
        {
            String productSkus = actionHelperUtils.getMapValue(payloadMap, "productSkus", true, "")
            List<String> productSkuList = Arrays.asList(productSkus.split(","))
            return productSkuList
        }
        else if("ADD_UPDATE_BULK_PRODUCTS".equalsIgnoreCase(operationType))
        {
            List<String> addedProductCodes = payloadMap.get("addedProductCodes") as List<String>
            return addedProductCodes
        }
        else if("ADD_UPDATE_BULK_VARIANT".equalsIgnoreCase(operationType))
        {
            List<String> addedProductCodes = payloadMap.get("addedProductVariantCodes") as List<String>
            return addedProductCodes
        }
    }

    private HttpEntity<String> buildHttpEntity(String jsonRequest, String systemToken) {
        HttpHeaders headers = new HttpHeaders()
        headers.setContentType(MediaType.APPLICATION_JSON)
        headers.set("system-token", systemToken)
        headers.set("Authorization", "Basic " + "U0VBTUxFU1M6M3F6ajY1a0w=")
        return new HttpEntity<>(jsonRequest, headers)
    }

    private String transformToChangeType(String operationType) throws ActionProcessingException {
        switch (operationType) {
            case "ADD_UPDATE_BULK_PRODUCTS":
            case "ADD_BULK_PRODUCT":
            case "ADD_UPDATE_BULK_VARIANT":
                return "CREATED"
            default:
                throw new ActionProcessingException("Invalid operation type: " + operationType)
        }
    }

    @Override
    protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Not implemented");
    }

}