package se.seamless.idm.actions.impl

import com.seamless.common.transaction.SystemToken
import groovy.transform.CompileStatic
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.w3c.dom.Document
import org.w3c.dom.Element
import se.seamless.idm.actions.AbstractAction
import se.seamless.idm.enums.LinkActionStatus;
import se.seamless.idm.exceptions.ActionProcessingException
import se.seamless.idm.exceptions.RetriableException
import se.seamless.idm.model.HelperTransaction

import java.util.concurrent.atomic.AtomicBoolean

@CompileStatic
class ERSPartnerOnboardAndModifyAction extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(ERSPartnerOnboardAndModifyAction.class);

    // Flag to track if action data has been loaded
    private final AtomicBoolean initialized = new AtomicBoolean(false)

    private String API_ENDPOINT
    private int RETRY_DELAY_MS
    private String UNAUTHORIZED_RESULT_CODE
    private String SUCCESS_RESULT_CODE
    private String RESPONSE_BASERESPONSE
    private String RESPONSE_COMMAND
    private String RESPONSE_TXN_STATUS
    private String RESPONSE_MESSAGE
    private String RESPONSE_RESULT_CODE
    private String RESPONSE_RESULT_MESSAGE

    @Override
    protected void loadActionData(HelperTransaction transaction) {
        // Only load data once per instance
        if (!initialized.getAndSet(true)) {
            log.info("Initializing ActionData for ERSPartnerOnboardAndModifyAction bean")
            API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-idm-ers-link:15500/erslink/v1/endpoint")
            RETRY_DELAY_MS = actionDataUtils.getActionDataInteger(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", transaction.getDefaultRetryDelayMs())
            UNAUTHORIZED_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "UNAUTHORIZED_RESULT_CODE", "401")
            SUCCESS_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "SUCCESS_RESULT_CODE", "200")
            RESPONSE_BASERESPONSE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_BASERESPONSE", "BaseResponse")
            RESPONSE_COMMAND = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_COMMAND", "COMMAND")
            RESPONSE_TXN_STATUS = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_TXN_STATUS", "TXNSTATUS")
            RESPONSE_MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_MESSAGE", "MESSAGE")
            RESPONSE_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_RESULT_CODE ", "resultCode")
            RESPONSE_RESULT_MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_RESULT_MESSAGE", "resultMessage")
            log.info("Action data loaded: API_ENDPOINT={}, RETRY_DELAY_MS={},UNAUTHORIZED_RESULT_CODE={},SUCCESS_RESULT_CODE={}",
                    API_ENDPOINT, RETRY_DELAY_MS, UNAUTHORIZED_RESULT_CODE, SUCCESS_RESULT_CODE)
        }

        // Always set the transaction retry delay
        transaction.setDefaultRetryDelayMs(RETRY_DELAY_MS)
    }

    @Override
    protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException {
        super.evaluatePreConditions(transaction);
        handleDependentLinkActions(transaction);
    }

    @Override
    protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.info("No validation defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId());
    }

    @Override
    protected void createRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Started creation of request for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId());
        try {
            String xmlRequest = createXmlRequest(transaction.getInboundRequest().getOperationType(),
                    transaction.getInboundRequest().getPayload(),
                    commonUtils.getSystemToken(transaction.getInboundRequest().getToken()));
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
        HttpEntity<String> requestEntity = buildHttpEntity(xmlRequest, transaction.getInboundRequest().getToken());
        try {
            String response = restTemplate.postForObject(API_ENDPOINT, requestEntity, String.class);
            transaction.getLinkActionInProgress().setResponse(response);
            log.debug("Received response: {}", response);
        }
        catch (Exception e) {
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL);
            log.error("Failed to make API call", e);
            throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL);
        }
    }

    @Override
    protected void handleResponse(HelperTransaction transaction) throws ActionProcessingException {
        String response = transaction.getLinkActionInProgress().getResponse();
        if (response == null || response.isEmpty()) {
            throw new ActionProcessingException("ERROR_EMPTY_RESPONSE");
        }
        Document doc = commonUtils.parseXml(response);
        Element rootElement = doc.getDocumentElement();
        if (rootElement.getNodeName().equals(RESPONSE_BASERESPONSE)) {
            String resultCode = rootElement.getElementsByTagName(RESPONSE_RESULT_CODE).item(0).getTextContent();
            if (resultCode.equals(UNAUTHORIZED_RESULT_CODE)) {
                String resultMessage = rootElement.getElementsByTagName(RESPONSE_RESULT_MESSAGE).item(0).getTextContent();
                throw new ActionProcessingException(resultMessage);
            }
        } else if (rootElement.getNodeName().equals(RESPONSE_COMMAND)) {
            String txnCode = rootElement.getElementsByTagName(RESPONSE_TXN_STATUS).item(0).getTextContent();
            if (!txnCode.equals(SUCCESS_RESULT_CODE)) {
                throw new ActionProcessingException(rootElement.getElementsByTagName(RESPONSE_MESSAGE).item(0).getTextContent());
            }
        }
    }

    @Override
    protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
        log.debug("Extracted action data map: {}", transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy());
    }

    @Override
    protected void callback(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Started callback for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId());
        String response = transaction.getLinkActionInProgress().getResponse();
        log.debug("Received response: {}", response);
    }

    private HttpEntity<String> buildHttpEntity(String xmlRequest, String systemToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_XML);
        headers.set("system-token", systemToken);
        return new HttpEntity<>(xmlRequest, headers);
    }

    private String createXmlRequest(String operationType, Object payload, SystemToken systemToken) throws Exception {
        Map<String, Object> payloadMap = commonUtils.convertObjectToMap(payload.toString());
        Map<String, Object> resellerInfoMap = commonUtils.convertObjectToMap(payloadMap.get("reseller"));
        Map<String, Object> dynamicDataMap = commonUtils.convertObjectToMap(resellerInfoMap.get("dynamicData"));
        Map<String, Object> extraParamMap = commonUtils.convertObjectToMap(
                commonUtils.convertObjectToMap(resellerInfoMap.get("extraParams")).get("parameters"));
        Map<String, Object> addressMap = commonUtils.convertObjectToMap(resellerInfoMap.get("address"));

        Document doc = actionHelperUtils.getDocumentBuilder().newDocument();
        Element commandElement = createCommandElement(operationType, doc, systemToken);
        Element dataElement = createDataElement(doc, commandElement, systemToken, resellerInfoMap,
                dynamicDataMap, extraParamMap, addressMap);
        createMsisdnsElement(doc, dataElement, resellerInfoMap);
        addInfoElements(doc, dataElement, resellerInfoMap, extraParamMap, dynamicDataMap);

        return actionHelperUtils.transformToString(doc);
    }

    private Element createCommandElement(String operationType, Document doc, SystemToken systemToken) {
        Element commandElement = doc.createElement("COMMAND");
        doc.appendChild(commandElement);

        String type = transformToChangeType(operationType);
        actionHelperUtils.addElement(doc, commandElement, "TYPE", type);
        actionHelperUtils.addElement(doc, commandElement, "DATE", commonUtils.convertTimestampToDate(systemToken.getStartTime(), "dd/MM/yyyy"));
        actionHelperUtils.addElement(doc, commandElement, "EXTNWCODE", "BD");
        actionHelperUtils.addElement(doc, commandElement, "EMPCODE", null);
        actionHelperUtils.addElement(doc, commandElement, "LOGINID", "OPERATOR");
        actionHelperUtils.addElement(doc, commandElement, "PASSWORD", "Seamless@1234");
        actionHelperUtils.addElement(doc, commandElement, "MSISDN", null);
        actionHelperUtils.addElement(doc, commandElement, "PIN", null);
        actionHelperUtils.addElement(doc, commandElement, "EXTREFNUM", systemToken.getErsReference());

        return commandElement;
    }

    private static String transformToChangeType(String operationType) throws ActionProcessingException {
        switch (operationType) {
            case "addReseller":
            case "RESELLER_ONBOARD":
                return "USERADDREQ";
            case "updateReseller":
            case "RESELLER_MODIFY":
                return "USERMODREQ";
            default:
                throw new ActionProcessingException("Invalid operation type: " + operationType);
        }
    }

    private Element createDataElement(Document doc, Element commandElement, SystemToken systemToken,
                                      Map<String, Object> resellerInfoMap, Map<String, Object> dynamicDataMap,
                                      Map<String, Object> extraParamMap, Map<String, Object> addressMap) throws ActionProcessingException {
        Element dataElement = doc.createElement("DATA");
        commandElement.appendChild(dataElement);

        actionHelperUtils.addElement(doc, dataElement, "NETWORKCODE", "BD");
        actionHelperUtils.addElement(doc, dataElement, "GEOGRAPHYCODE", actionHelperUtils.getMapValue(extraParamMap, "cluster", false, ""));    //Optional
        actionHelperUtils.addElement(doc, dataElement, "PARENTMSISDN", "");
        actionHelperUtils.addElement(doc, dataElement, "PARENTORIGINID", systemToken.getContext().getInitiator().getResellerId());
        actionHelperUtils.addElement(doc, dataElement, "PARENTEXTERNALCODE", "");
        actionHelperUtils.addElement(doc, dataElement, "USERCATCODE", resellerTypeIdMapping(actionHelperUtils.getMapValue(resellerInfoMap, "resellerTypeId", true, null)));
        actionHelperUtils.addElement(doc, dataElement, "USERNAME", actionHelperUtils.getMapValue(resellerInfoMap, "resellerName", true, ""));
        actionHelperUtils.addElement(doc, dataElement, "SHORTNAME", actionHelperUtils.getMapValue(extraParamMap, "shortCode", false, ""));  //Optional
        actionHelperUtils.addElement(doc, dataElement, "USERNAMEPREFIX", actionHelperUtils.getMapValue(dynamicDataMap, "prefix", true, ""));
        actionHelperUtils.addElement(doc, dataElement, "SUBSCRIBERCODE", null);
        actionHelperUtils.addElement(doc, dataElement, "EXTERNALCODE", actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, ""));
        actionHelperUtils.addElement(doc, dataElement, "CONTACTPERSON", actionHelperUtils.getMapValue(dynamicDataMap, "contactPersonName", false, ""));     //Optional
        actionHelperUtils.addElement(doc, dataElement, "CONTACTNUMBER", actionHelperUtils.getMapValue(dynamicDataMap, "contactPersonPhone", false, ""));    //Optional
        actionHelperUtils.addElement(doc, dataElement, "SSN", null);
        actionHelperUtils.addElement(doc, dataElement, "ADDRESS1", actionHelperUtils.getMapValue(addressMap, "street", false, ""));  //Optional
        actionHelperUtils.addElement(doc, dataElement, "ADDRESS2", null);
        actionHelperUtils.addElement(doc, dataElement, "CITY", actionHelperUtils.getMapValue(addressMap, "city", false, "")); //Optional
        actionHelperUtils.addElement(doc, dataElement, "STATE", actionHelperUtils.getMapValue(dynamicDataMap, "state", false, "")); //Optional
        actionHelperUtils.addElement(doc, dataElement, "COUNTRY", "Bangladesh");
        actionHelperUtils.addElement(doc, dataElement, "EMAILID", actionHelperUtils.getMapValue(addressMap, "email", true, ""));
        actionHelperUtils.addElement(doc, dataElement, "APPOINTMENTDATE", null);
        actionHelperUtils.addElement(doc, dataElement, "OUTLETTYPE", "ewe");
        actionHelperUtils.addElement(doc, dataElement, "SUBOUTLETTYPE", "wewewe");
        actionHelperUtils.addElement(doc, dataElement, "LBA", actionHelperUtils.getMapValue(dynamicDataMap, "lbaFlag", false, "N"));
        actionHelperUtils.addElement(doc, dataElement, "WEBLOGINID", actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, ""));
        actionHelperUtils.addElement(doc, dataElement, "WEBPASSWORD", "");

        return dataElement;
    }

    private void createMsisdnsElement(Document doc, Element dataElement, Map<String, Object> resellerInfoMap) throws ActionProcessingException {
        Element msisdnsElement = doc.createElement("MSISDNS");
        dataElement.appendChild(msisdnsElement);

        actionHelperUtils.addElement(doc, msisdnsElement, "MSISDN1", actionHelperUtils.getMapValue(resellerInfoMap, "resellerMSISDN", true, ""));
        actionHelperUtils.addElement(doc, msisdnsElement, "MSISDN2", null);
        actionHelperUtils.addElement(doc, msisdnsElement, "MSISDN3", null);
    }

    private void addInfoElements(Document doc, Element dataElement, Map<String, Object> resellerInfoMap,
                                 Map<String, Object> extraParamMap, Map<String, Object> dynamicDataMap) throws ActionProcessingException {
        actionHelperUtils.addElement(doc, dataElement, "INFO1", actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, ""));
        actionHelperUtils.addElement(doc, dataElement, "INFO2", actionHelperUtils.getMapValue(dynamicDataMap, "info2", false, ""));
        actionHelperUtils.addElement(doc, dataElement, "INFO3", actionHelperUtils.getMapValue(dynamicDataMap, "info3", false, ""));
        actionHelperUtils.addElement(doc, dataElement, "INFO4", actionHelperUtils.getMapValue(extraParamMap, "adminDistrict", false, ""));  //Optional
        actionHelperUtils.addElement(doc, dataElement, "INFO5", null);
        actionHelperUtils.addElement(doc, dataElement, "INFO6", null);
        actionHelperUtils.addElement(doc, dataElement, "INFO7", actionHelperUtils.getMapValue(extraParamMap, "region", false, ""));
        actionHelperUtils.addElement(doc, dataElement, "INFO8", actionHelperUtils.getMapValue(extraParamMap, "cluster", false, ""));
        actionHelperUtils.addElement(doc, dataElement, "INFO9", actionHelperUtils.getMapValue(extraParamMap, "territory", false, ""));
        actionHelperUtils.addElement(doc, dataElement, "INFO10", actionHelperUtils.getMapValue(extraParamMap, "marketThana", false, ""));
    }

    private String resellerTypeIdMapping(String resellerTypeId) {
        if ("GPCF".equalsIgnoreCase(resellerTypeId)) {
            return "RET";
        } else if ("GPC".equalsIgnoreCase(resellerTypeId)) {
            return "EUDIST";
        } else {
            return resellerTypeId.toUpperCase();
        }
    }
}
