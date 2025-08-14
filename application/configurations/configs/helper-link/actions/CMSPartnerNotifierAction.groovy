package se.seamless.idm.actions.impl;

import com.seamless.common.transaction.SystemToken;
import groovy.transform.CompileStatic;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.client.HttpClientErrorException;
import se.seamless.idm.actions.AbstractAction;
import se.seamless.idm.enums.LinkActionStatus;
import se.seamless.idm.exceptions.ActionProcessingException;
import se.seamless.idm.exceptions.FailedAtExternalSystemException;
import se.seamless.idm.exceptions.PayloadParsingException;
import se.seamless.idm.exceptions.RetriableException;
import se.seamless.idm.exceptions.SkippableActionException;
import se.seamless.idm.model.HelperTransaction;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;
import java.util.Objects;
import java.util.Arrays;
import com.google.gson.Gson;

@CompileStatic
class CMSPartnerNotifierAction extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(CMSPartnerNotifierAction.class);

    private final AtomicBoolean initialized = new AtomicBoolean(false);

    private String API_ENDPOINT;
    private String STATUS_CODE;
    private String MESSAGE;
    private List<String> RETRIABLE_STATUS_CODES;
    private int RETRY_DELAY_MS;
    private Set<String> SELF_PARENT_RESELLER_TYPES;
    
    @Override
    protected void loadActionData(HelperTransaction transaction) {
        // Only load data once per instance
        if (!initialized.getAndSet(true)) {
            log.info("Initializing ActionData for CMSPartnerNotifierAction bean");
            API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-idm-cms-link:15801/cmslink/v1/endpoint");
            STATUS_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "STATUS_CODE", "statusCode");
            MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "MESSAGE", "message");
            RETRIABLE_STATUS_CODES = actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "RETRIABLE_STATUS_CODES", Arrays.asList("500", "400"));
            RETRY_DELAY_MS = actionDataUtils.getActionDataInteger(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", transaction.getDefaultRetryDelayMs());
            SELF_PARENT_RESELLER_TYPES = new HashSet<>(actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "SELF_PARENT_RESELLER_TYPES", Arrays.asList("DIST", "CDIST")));
            log.info("Action data loaded: API_ENDPOINT={}, RETRY_DELAY_MS={}, STATUS_CODE={}, MESSAGE={}, RETRIABLE_STATUS_CODES={}, SELF_PARENT_RESELLER_TYPES={}", 
                    API_ENDPOINT, RETRY_DELAY_MS, STATUS_CODE, MESSAGE, RETRIABLE_STATUS_CODES, SELF_PARENT_RESELLER_TYPES);
        }

        // Always set the transaction retry delay
        transaction.setDefaultRetryDelayMs(RETRY_DELAY_MS);
    }

    @Override
    protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException, SkippableActionException {
        super.evaluatePreConditions(transaction);
        log.debug("No pre-conditions defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
    }

    @Override
    protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException {
        if(transaction.getActionResponseData().containsKey("GetResellerInfoAction")) {
            Map<String, Object> actionDataMap = transaction.getActionResponseData().get("GetResellerInfoAction");
            transaction.getDynamicData().put("parentResellerName", actionDataMap.get("parentResellerName"));
        }
        else {
            log.error("No GetResellerInfoAction found in action response data for requestId: {} with inboundTxnId: {}",
                    transaction.getInboundRequest().getId(),
                    transaction.getInboundRequest().getInboundTxnId());
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_VALIDATE_REQUEST);
            throw new ActionProcessingException("No GetResellerInfoAction found in action response data for requestId: " + transaction.getInboundRequest().getId());
        }
        log.info("Validation successful for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
    }

    @Override
    protected void createRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Started creation of request for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
        try {
            String jsonRequest = createJsonRequestString(
                    transaction.getInboundRequest().getPayload(),
                    commonUtils.getSystemToken(transaction.getInboundRequest().getToken()),
                    transaction
            );
            transaction.getLinkActionInProgress().setRequest(jsonRequest);
            log.info("Created JSON request: {}", jsonRequest);
        } catch (Exception e) {
            log.error("Failed to create JSON request", e);
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_CREATE_REQUEST);
            throw new ActionProcessingException("Failed to create JSON request: " + e.getMessage());
        }
    }

    @Override
    protected void makeApiCall(HelperTransaction transaction) throws RetriableException {
        String jsonRequest = transaction.getLinkActionInProgress().getRequest();
        HttpEntity<String> requestEntity = buildHttpEntity(jsonRequest, transaction.getInboundRequest().getToken());

        try {
            String response = restTemplate.postForObject(API_ENDPOINT, requestEntity, String.class);
            transaction.getLinkActionInProgress().setResponse(response);
            log.debug("Received response: {}", response);
        } catch (HttpClientErrorException.BadRequest e) {
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL);
            log.error("Failed to make API call", e);
            throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL);
        }
        catch (Exception e) {
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL);
            log.error("Failed to make API call", e);
            throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL);
        }
    }

    @Override
    protected void handleResponse(HelperTransaction transaction) throws ActionProcessingException, FailedAtExternalSystemException, PayloadParsingException, RetriableException {
        if(transaction.getLinkActionInProgress().getResponse() == null) {
            log.error("NULL response from CMS");
            throw new FailedAtExternalSystemException("NULL response from CMS");
        }
        Map<String, Object> responseMap = commonUtils.convertObjectToMap(transaction.getLinkActionInProgress().getResponse());
        if(!responseMap.containsKey(STATUS_CODE)) {
            log.error("Invalid response from CMS: " + responseMap);
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_EXTERNAL_SYSTEM);
            throw new ActionProcessingException("Invalid response from CMS: " + responseMap);
        }

        Map<String, Object> actionDataMap = transaction.getActionResponseData().get(transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy());
        actionDataMap.put(STATUS_CODE, responseMap.get(STATUS_CODE));
        actionDataMap.put(MESSAGE, responseMap.get(MESSAGE));
        Integer statusCode = (Integer) responseMap.get(STATUS_CODE);

        if(RETRIABLE_STATUS_CODES.contains(responseMap.get(STATUS_CODE))) {
            log.debug("Response from CMS: " + responseMap.get(MESSAGE));
            log.error("Retriable status code from CMS: " + statusCode);
            throw new RetriableException(responseMap.get(MESSAGE).toString(), LinkActionStatus.FAILED_AT_HANDLE_RESPONSE);
        }

        if(statusCode != 200) {
            log.error("Failed to notify partner data in CMS: " + responseMap.get("message"));
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_EXTERNAL_SYSTEM);
            throw new FailedAtExternalSystemException("Failed to notify partner data in CMS: " + responseMap.get("message"));
        }
    }

    @Override
    protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
        String action = transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy();
        log.debug("Extracted action data map: " + action);
    }

    @Override
    protected void callback(HelperTransaction transaction) throws ActionProcessingException {
        log.debug("No callback defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
    }

    private String createJsonRequestString(String payload, SystemToken systemToken, HelperTransaction transaction) throws ActionProcessingException {
        Map<String, Object> jsonRequestMap = new HashMap<>();
        Map<String, Object> payloadMap = commonUtils.convertObjectToMap(payload);
        Map<String, Object> resellerInfoMap = commonUtils.convertObjectToMap(payloadMap.get("reseller"));
        Map<String, Object> dynamicDataMap = commonUtils.convertObjectToMap(resellerInfoMap.get("dynamicData"));
        Map<String, Object> extraParamMap = commonUtils.convertObjectToMap(commonUtils
                .convertObjectToMap(resellerInfoMap.get("extraParams")).get("parameters"));

        // Extract posCategories from pos list
        String posCategories = Optional.ofNullable(dynamicDataMap.get("pos"))
                .filter(obj -> obj instanceof List)
                .map(obj -> {
                    List<?> list = (List<?>) obj;
                    return list.stream()
                            .filter(item -> item instanceof Map)
                            .map(item -> (Map<String, Object>) item)
                            .map(pos -> String.valueOf(pos.get("posCategory")))
                            .filter(Objects::nonNull)
                            .reduce("", (a, b) -> a.isEmpty() ? b : a + "," + b);
                })
                .orElse("");

        String commissionPaymentMode = Optional.ofNullable(dynamicDataMap.get("commission"))
                .filter(obj -> obj instanceof List)
                .map(obj -> {
                    List<?> list = (List<?>) obj;
                    return list.stream()
                            .filter(item -> item instanceof Map)
                            .map(item -> (Map<String, Object>) item)
                            .filter(commission -> "true".equals(commission.get("isPrimary")))
                            .map(commission -> String.valueOf(commission.get("paymentMode")))
                            .findFirst()
                            .orElse("");
                })
                .orElse("");

        String currentDate = commonUtils.convertTimestampToDate(System.currentTimeMillis(), "yyyy-MM-dd HH:mm:ss") + ".0";
            Map<String, Object> jsonPayloadMap = new HashMap<>();

            String msisdn = (String) resellerInfoMap.get("resellerMSISDN");
            Long msisdnLong = msisdn != null ? Long.parseLong(msisdn) : null;

            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "retailerMsisdn", msisdnLong);
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "adid", "");
            String dtrCode = getDTRCode(transaction, resellerInfoMap);
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "dtrCode", dtrCode);
            String dtrName = getDTRName(transaction, resellerInfoMap);
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "dtrName", dtrName);
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "posName", actionHelperUtils.getMapValue(resellerInfoMap, "resellerName", true, null));
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "posRegion", actionHelperUtils.getMapValue(extraParamMap, "region", true, null));
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "posArea", actionHelperUtils.getMapValue(extraParamMap, "cluster", true, null));
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "posTerritory", actionHelperUtils.getMapValue(extraParamMap, "territory", true, null));
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "partnerType", posCategories.isEmpty() ? "" : posCategories);
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "ersMsisdn", msisdnLong);
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "posStatus", determineStatus(actionHelperUtils.getMapValue(resellerInfoMap, "status", true, null)));
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "channel", actionHelperUtils.getMapValue(extraParamMap, "channelName", true, null));
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "commissionPaymentMode", commissionPaymentMode);
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "posCode", actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, null));
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "userOriginID", actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, null));
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "ersPosCode", actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, null));
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "modifiedDate", currentDate);
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "commissionCategory", "");
            actionHelperUtils.addParamsToJsonRequest(jsonPayloadMap, "creationDate", currentDate);

            Gson gson = new Gson();
            String jsonString = gson.toJson(jsonPayloadMap);
            log.info("Payload string: {}", jsonString);

            jsonRequestMap.put("properties", new Object());
            jsonRequestMap.put("routing_key", "pos_key_dms");
            jsonRequestMap.put("payload", jsonString);
            jsonRequestMap.put("payload_encoding", "string");
            
            return commonUtils.parseJson(jsonRequestMap);
        }

    protected String determineStatus(String status) throws ActionProcessingException {
        switch (status) {
            case "Active":
                return "ACTIVE";
            case "Deactivated":
                return "DEBOARDED";
            case "Blocked":
                return "SUSPENDED";
            default:
                return status;
        }
    }

    private HttpEntity<String> buildHttpEntity(String jsonRequest, String systemToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("system-token", systemToken);
        headers.set("Authorization", "Basic " + "U0VBTUxFU1M6M3F6ajY1a0w=");
        return new HttpEntity<>(jsonRequest, headers);
    }

    private String getDTRCode(HelperTransaction transaction, Map<String, Object> resellerInfoMap) throws ActionProcessingException {
        String resellerType = actionHelperUtils.getMapValue(resellerInfoMap, "resellerTypeId", true, null);
        if (SELF_PARENT_RESELLER_TYPES.contains(resellerType)) {
            return actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, null);
        } else {
            return actionHelperUtils.getMapValue(resellerInfoMap, "parentResellerId", true, null);
        }
    }

    private String getDTRName(HelperTransaction transaction, Map<String, Object> resellerInfoMap) throws ActionProcessingException {
        String resellerType = actionHelperUtils.getMapValue(resellerInfoMap, "resellerTypeId", true, null);
        if (SELF_PARENT_RESELLER_TYPES.contains(resellerType)) {
            return actionHelperUtils.getMapValue(resellerInfoMap, "resellerName", true, null);
        } else {
            return transaction.getDynamicData().containsKey("parentResellerName") ? transaction.getDynamicData().get("parentResellerName").toString() : "";
        }
    }
} 