package se.seamless.idm.actions.impl;

import com.seamless.common.transaction.SystemToken;
import groovy.transform.CompileStatic;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import se.seamless.idm.actions.AbstractAction;
import se.seamless.idm.enums.LinkActionStatus;
import se.seamless.idm.exceptions.ActionProcessingException;
import se.seamless.idm.exceptions.RetriableException;
import se.seamless.idm.exceptions.SkippableActionException;
import se.seamless.idm.model.HelperTransaction;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;

@CompileStatic
class MFSPartnerOnBoardAndModifyAction extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(MFSPartnerOnBoardAndModifyAction.class);

    private final AtomicBoolean initialized = new AtomicBoolean(false);

    private String API_ENDPOINT;
    private String RESPONSE_BASERESPONSE;
    private String RESPONSE_COMMAND;
    private String RESPONSE_TXN_STATUS;
    private String RESPONSE_MESSAGE;
    private String RESPONSE_RESULT_CODE;
    private String RESPONSE_RESULT_MESSAGE;
    private String SUCCESS_RESULT_CODE;
    private String UNASSIGNED_RESULT_CODE;
    private String RETRY_CONTENT_RESULT_CODE;
    private String UNAUTHORIZED_RESULT_CODE;
    private String MESSAGE;
    private int RETRY_DELAY_MS;
    private Set<String> SELF_PARENT_RESELLER_TYPES;
    
    @Override
    protected void loadActionData(HelperTransaction transaction) {
        // Only load data once per instance
        if (!initialized.getAndSet(true)) {
            log.info("Initializing ActionData for MFSPartnerOnBoardAndModifyAction bean");
            API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-idm-mfs-link:15600/mfslink/v1/transfer-request");
            RESPONSE_BASERESPONSE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_BASERESPONSE", "BaseResponse");
            RESPONSE_COMMAND = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_COMMAND", "COMMAND");
            RESPONSE_TXN_STATUS = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_TXN_STATUS", "TXNSTATUS");
            RESPONSE_MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_MESSAGE", "MESSAGE");
            RESPONSE_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_RESULT_CODE", "resultCode");
            RESPONSE_RESULT_MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_RESULT_MESSAGE", "resultMessage");
            SUCCESS_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "SUCCESS_RESULT_CODE", "200");
            UNASSIGNED_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "UNASSIGNED_RESULT_CODE", "250");
            RETRY_CONTENT_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RETRY_CONTENT_RESULT_CODE", "205");
            UNAUTHORIZED_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "UNAUTHORIZED_RESULT_CODE", "401");
            MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "MESSAGE", "message");
            RETRY_DELAY_MS = actionDataUtils.getActionDataInteger(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", transaction.getDefaultRetryDelayMs());
            SELF_PARENT_RESELLER_TYPES = new HashSet<>(actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "SELF_PARENT_RESELLER_TYPES", Arrays.asList("DIST", "CDIST")));
            log.info("Action data loaded: API_ENDPOINT: {}, MESSAGE: {}, RESPONSE_BASERESPONSE: {}, RESPONSE_COMMAND: {}, RESPONSE_TXN_STATUS: {}, RESPONSE_MESSAGE: {}, RESPONSE_RESULT_CODE: {}, RESPONSE_RESULT_MESSAGE: {}, SUCCESS_RESULT_CODE: {}, UNASSIGNED_RESULT_CODE: {}, RETRY_CONTENT_RESULT_CODE: {}, UNAUTHORIZED_RESULT_CODE: {}, RETRY_DELAY_MS: {}, SELF_PARENT_RESELLER_TYPES: {}",
                    API_ENDPOINT, MESSAGE, RESPONSE_BASERESPONSE, RESPONSE_COMMAND, RESPONSE_TXN_STATUS, RESPONSE_MESSAGE, RESPONSE_RESULT_CODE, RESPONSE_RESULT_MESSAGE, SUCCESS_RESULT_CODE, UNASSIGNED_RESULT_CODE, RETRY_CONTENT_RESULT_CODE, UNAUTHORIZED_RESULT_CODE, RETRY_DELAY_MS, SELF_PARENT_RESELLER_TYPES);
        }

        // Always set the transaction retry delay
        transaction.setDefaultRetryDelayMs(RETRY_DELAY_MS);
    }

    @Override
    protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException, SkippableActionException {
        super.evaluatePreConditions(transaction);
        log.info(
                "No pre-conditions defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
    }

    @Override
    protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Validating request for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
        
        Map<String, Object> getResellerInfoActionResponseData = transaction.getActionResponseData().get("GetResellerInfoAction");
        if (getResellerInfoActionResponseData == null) {
            log.error("No GetResellerInfoAction found in action response data for requestId: {} with inboundTxnId: {}", 
                    transaction.getInboundRequest().getId(),
                    transaction.getInboundRequest().getInboundTxnId()); 
            throw new ActionProcessingException("No GetResellerInfoAction found in action response data for requestId: " + transaction.getInboundRequest().getId());
        }
        transaction.getDynamicData().put("parentResellerMfsMSISDN", getResellerInfoActionResponseData.get("parentResellerMfsMSISDN"));
    }

    @Override
    protected void createRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.info(
                "Started creation of request for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
        try {
            String xmlRequest = createXmlRequest(transaction, commonUtils.getSystemToken(transaction.getInboundRequest().getToken()));
            transaction.getLinkActionInProgress().setRequest(xmlRequest);
            log.debug("Created XML request: {}", xmlRequest);
        } catch (Exception e) {
            log.error("Failed to create XML request", e);
            throw new ActionProcessingException("Failed to create XML request: " + e.getMessage());
        }
    }

    @Override
    protected void makeApiCall(HelperTransaction transaction) throws RetriableException {
        String xmlRequest = transaction.getLinkActionInProgress().getRequest();
        String bearerAuthToken = "U0VBTUxFU1M6M3F6ajY1a0w=";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_XML);
        headers.set("system-token", transaction.getInboundRequest().getToken());
        headers.setBearerAuth(bearerAuthToken);
        HttpEntity<String> requestEntity = new HttpEntity<>(xmlRequest, headers);
        try {
            String response = restTemplate.postForObject(API_ENDPOINT, requestEntity, String.class);
            transaction.getLinkActionInProgress().setResponse(response);
            log.debug("Received response: {}", response);
        } catch (Exception e) {
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL);
            log.error("Failed to make API call", e);
            throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL);
        }
    }

    @Override
    protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Not extracting any response data for requestId: {} with inboundTxnId: {}", 
                transaction.getInboundRequest().getId(), 
                transaction.getInboundRequest().getInboundTxnId());
    }

    @Override
    protected void handleResponse(HelperTransaction transaction) throws ActionProcessingException {
        String response = transaction.getLinkActionInProgress().getResponse();
        if (response == null || response.isEmpty()) {
            throw new ActionProcessingException("Received empty response");
        }

        Document doc = commonUtils.parseXml(response);
        Element rootElement = doc.getDocumentElement();

        if (rootElement.getNodeName().equals(RESPONSE_BASERESPONSE)) {
            String resultCode = rootElement.getElementsByTagName(RESPONSE_RESULT_CODE).item(0).getTextContent();
            if (UNAUTHORIZED_RESULT_CODE.contains(resultCode)) {
                String resultMessage = rootElement.getElementsByTagName(RESPONSE_RESULT_MESSAGE).item(0).getTextContent();
                throw new ActionProcessingException(resultMessage);
            }
        } else if (rootElement.getNodeName().equals(RESPONSE_COMMAND)) {
            String txnStatus = rootElement.getElementsByTagName(RESPONSE_TXN_STATUS).item(0).getTextContent();
            if (!txnStatus.equals(SUCCESS_RESULT_CODE)) {
                String message = rootElement.getElementsByTagName(RESPONSE_MESSAGE).item(0).getTextContent();
                if (txnStatus.equals(UNASSIGNED_RESULT_CODE)) {
                    throw new ActionProcessingException("Transaction ambiguous: " + message);
                } else if (txnStatus.equals(RETRY_CONTENT_RESULT_CODE)) {
                    throw new ActionProcessingException("Transaction under process: " + message);
                } else {
                    throw new ActionProcessingException(message);
                }
            }
        }
    }

    @Override
    protected void callback(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Not calling any callback for requestId: {} with inboundTxnId: {}", 
                transaction.getInboundRequest().getId(), 
                transaction.getInboundRequest().getInboundTxnId());
    }

    private String createXmlRequest(HelperTransaction transaction, SystemToken systemToken) throws Exception {
        Map<String, Object> payloadMap = commonUtils.convertObjectToMap(transaction.getInboundRequest().getPayload());
        Map<String, Object> resellerInfoMap = commonUtils.convertObjectToMap(payloadMap.get("reseller"));
        Map<String, Object> dynamicDataMap = commonUtils.convertObjectToMap(resellerInfoMap.get("dynamicData"));
        Map<String, Object> extraParamMap = commonUtils.convertObjectToMap(commonUtils
                .convertObjectToMap(resellerInfoMap.get("extraParams")).get("parameters"));
        Map<String, Object> addressMap = commonUtils.convertObjectToMap(resellerInfoMap.get("address"));
        Document doc = actionHelperUtils.getDocumentBuilder().newDocument();

        Element commandElement = doc.createElement("COMMAND");
        doc.appendChild(commandElement);

        actionHelperUtils.addElement(doc, commandElement, "TYPE", "REGMODCUREQ");
        actionHelperUtils.addElement(doc, commandElement, "USERID", "");  //Optional DMS will not send
        actionHelperUtils.addElement(doc, commandElement, "PREFIX", actionHelperUtils.getMapValue(dynamicDataMap, "prefix", true, ""));
        actionHelperUtils.addElement(doc, commandElement, "FIRSTNAME", actionHelperUtils.getMapValue(resellerInfoMap, "resellerName", true, ""));
        actionHelperUtils.addElement(doc, commandElement, "LASTNAME", actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, ""));
        actionHelperUtils.addElement(doc, commandElement, "SHORTNAME", actionHelperUtils.getMapValue(extraParamMap, "shortCode", false, "")); // Optional, not sent
        actionHelperUtils.addElement(doc, commandElement, "AGENTCODE", actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, ""));
        actionHelperUtils.addElement(doc, commandElement, "IDTYPE", "NID");
        actionHelperUtils.addElement(doc, commandElement, "IDVALUE", actionHelperUtils.getMapValue(dynamicDataMap, "nidNumber", true, ""));
        actionHelperUtils.addElement(doc, commandElement, "ADDRESS1", actionHelperUtils.getMapValue(addressMap, "street", true, ""));
        actionHelperUtils.addElement(doc, commandElement, "ADDRESS2", null);
        actionHelperUtils.addElement(doc, commandElement, "CITY", actionHelperUtils.getMapValue(extraParamMap, "adminDistrict", false, ""));
        actionHelperUtils.addElement(doc, commandElement, "STATE", actionHelperUtils.getMapValue(extraParamMap, "adminThana", false, ""));
        actionHelperUtils.addElement(doc, commandElement, "COUNTRY", "BD"); // Constant Value
        actionHelperUtils.addElement(doc, commandElement, "EMAILID", actionHelperUtils.getMapValue(addressMap, "email", false, ""));
        actionHelperUtils.addElement(doc, commandElement, "DESIGNATION", actionHelperUtils.getMapValue(dynamicDataMap, "companyType", false, ""));
        actionHelperUtils.addElement(doc, commandElement, "CONTACTPERSON", actionHelperUtils.getMapValue(dynamicDataMap, "contactPersonName", false, ""));
        actionHelperUtils.addElement(doc, commandElement, "CONTACTNO", actionHelperUtils.getMapValue(dynamicDataMap, "contactPersonPhone", false, ""));
        actionHelperUtils.addElement(doc, commandElement, "GENDER", actionHelperUtils.getMapValue(extraParamMap, "gender", false, ""));
        actionHelperUtils.addElement(doc, commandElement, "DOB", actionHelperUtils.getMapValue(dynamicDataMap, "dob", false, ""));
        actionHelperUtils.addElement(doc, commandElement, "REGISTRATIONFORMNO", ""); // Optional, not sent
        actionHelperUtils.addElement(doc, commandElement, "LOGINID", systemToken.getErsReference());
        actionHelperUtils.addElement(doc, commandElement, "MSISDN", formatMsisdn(actionHelperUtils.getMapValue(resellerInfoMap, "resellerMSISDN", true, "")));
        actionHelperUtils.addElement(doc, commandElement, "PREFLANG", "Bangla");
        actionHelperUtils.addElement(doc, commandElement, "OWNERMSISDN", "01745674567");
        String parentMsisdn = formatMsisdn(getParentMsisdn(transaction, resellerInfoMap));
        actionHelperUtils.addElement(doc, commandElement, "PARENTMSISDN", parentMsisdn);
        actionHelperUtils.addElement(doc, commandElement, "GEO", actionHelperUtils.getMapValue(extraParamMap, "marketThana", true, null));

        String action = transformToChangeAction(transaction.getInboundRequest().getOperationType());
        actionHelperUtils.addElement(doc, commandElement, "ACTION", action);
        actionHelperUtils.addElement(doc, commandElement, "SYSTEM", "DMS");

        String userCategory = resellerTypeIdMapping(actionHelperUtils.getMapValue(resellerInfoMap, "resellerTypeId", true, null));
        actionHelperUtils.addElement(doc, commandElement, "USERCATEGORY", userCategory);
        actionHelperUtils.addElement(doc, commandElement, "GROUPROLECODE", ""); // Optional, not sent
        actionHelperUtils.addElement(doc, commandElement, "MOBGROUPROLECODE", ""); // Optional, not sent
        actionHelperUtils.addElement(doc, commandElement, "GRADECODE", ""); // Optional, not sent
        actionHelperUtils.addElement(doc, commandElement, "TCP", ""); // Optional, not sent
        if ("RESELLER_ONBOARD".equalsIgnoreCase(transaction.getInboundRequest().getOperationType()) || 
            "addReseller".equalsIgnoreCase(transaction.getInboundRequest().getOperationType())) {
            actionHelperUtils.addElement(doc, commandElement, "WALLETBANKSTATUS", "A");
        } else {
            actionHelperUtils.addElement(doc, commandElement, "WALLETBANKSTATUS", "M");
        }
        actionHelperUtils.addElement(doc, commandElement, "SESSION_ID", systemToken.getErsReference());
        actionHelperUtils.addElement(doc, commandElement, "TRID", systemToken.getErsReference());

        StringWriter writer = new StringWriter();
        actionHelperUtils.getTransformer().transform(new DOMSource(doc), new StreamResult(writer));

        return writer.toString();
    }

    private String resellerTypeIdMapping(String resellerTypeId) {
        if ("DIST".equalsIgnoreCase(resellerTypeId)) {
            return "SD";
        } else if ("SE".equalsIgnoreCase(resellerTypeId)) {
            return "SE";
        } else if ("RET".equalsIgnoreCase(resellerTypeId)) {
            return "RTD";
        } else if ("GPCF".equalsIgnoreCase(resellerTypeId)) {
            return "POS";
        } else {
            throw new IllegalArgumentException("Invalid resellerTypeId");
        }
    }

    private String transformToChangeAction(String operationType) throws ActionProcessingException {
        switch (operationType) {
            case "addReseller":
            case "RESELLER_ONBOARD":
                return "ADD";
            case "updateReseller":
            case "RESELLER_MODIFY":
                return "MOD";
            default:
                throw new ActionProcessingException("Invalid operation type: " + operationType);
        }
    }

    private String getParentMsisdn(HelperTransaction transaction, Map<String, Object> resellerInfoMap) throws ActionProcessingException {
        Map<String, Object> extraParamMap = commonUtils.convertObjectToMap(resellerInfoMap.get("extraParams"));
        if(Objects.isNull(extraParamMap) || extraParamMap.isEmpty()) {
            throw new ActionProcessingException("Extra parameters not found in reseller info map");
        }
        Map<String, Object> parametersMap = commonUtils.convertObjectToMap(extraParamMap.get("parameters"));
        if(Objects.isNull(parametersMap) || parametersMap.isEmpty()) {
            throw new ActionProcessingException("Parameters not found in extra parameters map");
        }
        return SELF_PARENT_RESELLER_TYPES.contains(actionHelperUtils.getMapValue(resellerInfoMap, "resellerTypeId", true, null)) ? 
            actionHelperUtils.getMapValue(parametersMap, "mfsMsisdn", true, null) : 
            transaction.getDynamicData().get("parentResellerMfsMSISDN").toString();
    }

    private String formatMsisdn(String msisdn) {
        if (msisdn != null && msisdn.startsWith("88")) {
            return msisdn.substring(2);
        }
        return msisdn;
    }
}
