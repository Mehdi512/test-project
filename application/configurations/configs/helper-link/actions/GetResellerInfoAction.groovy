package se.seamless.idm.actions.impl;

import groovy.transform.CompileStatic;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicBoolean;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;

import se.seamless.idm.actions.AbstractAction;
import se.seamless.idm.exceptions.ActionProcessingException;
import se.seamless.idm.exceptions.RetriableException;
import se.seamless.idm.exceptions.SkippableActionException;
import se.seamless.idm.model.HelperTransaction;

@CompileStatic
class GetResellerInfoAction extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(GetResellerInfoAction.class);

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
            log.info("Loading action data for GetResellerInfoAction, requestId: {}", transaction.getInboundRequest().getId());
            API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-dealer-management:8033/dms/auth/getResellerInfo");
            RETRY_DELAY_MS = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", "1000");
            STATUS_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "STATUS_CODE", "resultCode");
            MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "MESSAGE", "resultDescription");
            LIMIT_DYNAMIC_DATA = actionDataUtils.getActionDataBoolean(transaction.getLinkActionInProgress(), "LIMIT_DYNAMIC_DATA", true);
            RETRIABLE_STATUS_CODES = actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "RETRIABLE_STATUS_CODES", Arrays.asList("500", "400"));
            log.info("Action data loaded: API_ENDPOINT={}, RETRY_DELAY_MS={}, STATUS_CODE={}, MESSAGE={}, RETRIABLE_STATUS_CODES={}", 
                    API_ENDPOINT, RETRY_DELAY_MS, STATUS_CODE, MESSAGE, RETRIABLE_STATUS_CODES);
        }   
        transaction.setDefaultRetryDelayMs(Integer.parseInt(RETRY_DELAY_MS));
    }

    @Override
    protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException, SkippableActionException {
        super.evaluatePreConditions(transaction);
        log.debug("No preconditions to evaluate for GetResellerInfoAction, requestId: {}", transaction.getInboundRequest().getId());
    }

    @Override
    protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException, SkippableActionException {
        log.info("Validating request for GetResellerInfoAction, requestId: {}", transaction.getInboundRequest().getId());
        Map<String, Object> data = commonUtils.convertObjectToMap(transaction.getInboundRequest().getPayload());
        if(Objects.isNull(data)) {
            log.error("Payload is null for requestId: {}", transaction.getInboundRequest().getId());
            throw new ActionProcessingException("Payload is null for requestId: " + transaction.getInboundRequest().getId());
        }
        Map<String, Object> resellerInfoMap = commonUtils.convertObjectToMap(data.get("reseller"));
        if(Objects.isNull(resellerInfoMap)) {
            log.error("Reseller info is null for requestId: {}", transaction.getInboundRequest().getId());
            throw new ActionProcessingException("Reseller info is null for requestId: " + transaction.getInboundRequest().getId());
        }
        if(resellerInfoMap.get("parentResellerId") == null || resellerInfoMap.get("parentResellerId").toString().isEmpty()) {
            log.error("Parent reseller ID is null or empty for requestId: {}", transaction.getInboundRequest().getId());
            throw new ActionProcessingException("Parent reseller ID is null or empty for requestId: " + transaction.getInboundRequest().getId());
        }
        transaction.getDynamicData().put("parentResellerId", resellerInfoMap.get("parentResellerId"));
        log.info("Request validated for GetResellerInfoAction, requestId: {}", transaction.getInboundRequest().getId());
    }

    @Override
    protected void createRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Creating request for GetResellerInfoAction, requestId: {}", transaction.getInboundRequest().getId());
        Map<String, Object> getResellerInfoRequest = new HashMap<>();
        Map<String, Object> dealerIdMap = new HashMap<>();
        dealerIdMap.put("id", transaction.getDynamicData().get("parentResellerId"));
        dealerIdMap.put("type", "RESELLERID");
        getResellerInfoRequest.put("dealerID", dealerIdMap);
        getResellerInfoRequest.put("fetchAccountBalanceInformation", false);
        transaction.getLinkActionInProgress().setRequest(commonUtils.parseJson(getResellerInfoRequest));
    }

    @Override
    protected void makeApiCall(HelperTransaction transaction) throws RetriableException {
        log.info("Making API call for GetResellerInfoAction, requestId: {}", transaction.getInboundRequest().getId());
        HttpEntity<String> requestEntity = buildHttpEntity(transaction.getLinkActionInProgress().getRequest(), transaction.getInboundRequest().getToken(), transaction.getInboundRequest().getAuthorization());
        String API = constructAPIEndpoint(transaction.getLinkActionInProgress().getRequest());
        String response = restTemplate.postForObject(API, requestEntity, String.class);
        transaction.getLinkActionInProgress().setResponse(response);
    }

    @Override
    protected void handleResponse(HelperTransaction transaction) throws ActionProcessingException {
        String requestId = transaction.getInboundRequest().getInboundTxnId();
        log.info("Handling response for GetResellerInfoAction, requestId: {}", requestId);
        
        String response = transaction.getLinkActionInProgress().getResponse();
        if (Objects.isNull(response) || response.isEmpty()) {
            throw new ActionProcessingException("Response is null or empty for requestId: " + requestId);
        }

        Map<String, Object> responseMap = commonUtils.convertObjectToMap(response);
        if (Objects.isNull(responseMap) || responseMap.isEmpty()) {
            throw new ActionProcessingException("Response map is null or empty for requestId: " + requestId);
        }

        if (!"0".equals(responseMap.get(STATUS_CODE).toString())) {
            throw new ActionProcessingException("Response is not successful for GetResellerInfoAction, requestId: " + requestId);
        }

        Map<String, Object> resellerInfo = commonUtils.convertObjectToMap(responseMap.get("resellerInfo"));
        if (Objects.isNull(resellerInfo) || Objects.isNull(resellerInfo.get("resellerData"))) {
            throw new ActionProcessingException("Reseller info is null or empty for requestId: " + requestId);
        }

        Map<String, Object> resellerDataMap = commonUtils.convertObjectToMap(resellerInfo.get("resellerData"));
        if(Objects.isNull(resellerDataMap.get("extraParams")) || Objects.isNull(commonUtils.convertObjectToMap(resellerDataMap.get("extraParams")).get("parameters"))) {    
            throw new ActionProcessingException("Extra parameters not found in reseller info for requestId: " + requestId);
        }

        Map<String, Object> parametersMap = commonUtils.convertObjectToMap(commonUtils.convertObjectToMap(resellerDataMap.get("extraParams")).get("parameters"));
        if(Objects.isNull(parametersMap) || parametersMap.isEmpty()) {
            throw new ActionProcessingException("Parameters not found in extra parameters map for requestId: " + requestId);
        }
        
        log.info("Response is successful for GetResellerInfoAction, requestId: {}", requestId);
    }

    @Override
    protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Extracting response data for GetResellerInfoAction, requestId: {}", transaction.getInboundRequest().getId());
        String response = transaction.getLinkActionInProgress().getResponse();
        Map<String, Object> responseMap = commonUtils.convertObjectToMap(response);
        Map<String, Object> resellerDataMap = commonUtils.convertObjectToMap(commonUtils.convertObjectToMap(responseMap.get("resellerInfo")).get("resellerData"));
        Map<String, Object> parametersMap = commonUtils.convertObjectToMap(commonUtils.convertObjectToMap(resellerDataMap.get("extraParams")).get("parameters"));
        Map<String, Object> actionDataMap = transaction.getActionResponseData().get(transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy());
        actionDataMap.put("parentResellerName", actionHelperUtils.getMapValue(resellerDataMap, "resellerName", true, null));
        actionDataMap.put("parentMSISDN", actionHelperUtils.getMapValue(resellerDataMap, "resellerMSISDN", true, null));
        actionDataMap.put("parentResellerMfsMSISDN", actionHelperUtils.getMapValue(parametersMap, "mfsMsisdn", false, ""));
        //Add data as per the requirement
        log.info("Extracted response data for GetResellerInfoAction, requestId: {}", transaction.getInboundRequest().getId());
    }

    @Override
    protected void callback(HelperTransaction transaction) throws ActionProcessingException {
        log.info("No callback required for GetResellerInfoAction, requestId: {}", transaction.getInboundRequest().getId());
    }

    private HttpEntity<String> buildHttpEntity(String jsonRequest, String systemToken, String authorization) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("system-token", systemToken);
        headers.set("authorization", authorization);
        return new HttpEntity<>(jsonRequest, headers);
    }

    private String constructAPIEndpoint(String request) {
        String API = API_ENDPOINT + "?limit-dynamic-data=" + LIMIT_DYNAMIC_DATA;
        return API;
    }
}