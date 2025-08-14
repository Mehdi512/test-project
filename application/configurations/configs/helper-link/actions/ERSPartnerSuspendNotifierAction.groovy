package se.seamless.idm.actions.impl

import com.seamless.common.transaction.SystemToken
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
import groovy.transform.CompileStatic

import java.util.concurrent.atomic.AtomicBoolean

@CompileStatic
class ERSPartnerSuspendNotifierAction extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(ERSPartnerSuspendNotifierAction)

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
            log.info("Initializing ActionData for ERSPartnerSuspendNotifierAction bean")
            API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-idm-ers-link:15500/erslink/v1/endpoint?LOGIN=ers1&PASSWORD=1357&REQUEST_GATEWAY_CODE=WEB&REQUEST_GATEWAY_TYPE=WEB&SERVICE_PORT=100&SOURCE_TYPE=WEB")
            RETRY_DELAY_MS = actionDataUtils.getActionDataInteger(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", transaction.getDefaultRetryDelayMs())
            UNAUTHORIZED_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "UNAUTHORIZED_RESULT_CODE", "401")
            SUCCESS_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "SUCCESS_RESULT_CODE", "200")
            RESPONSE_BASERESPONSE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_BASERESPONSE", "BaseResponse")
            RESPONSE_COMMAND = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_COMMAND", "COMMAND")
            RESPONSE_TXN_STATUS = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_TXN_STATUS", "TXNSTATUS")
            RESPONSE_MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_MESSAGE", "MESSAGE")
            RESPONSE_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), " RESPONSE_RESULT_CODE ", "resultCode")
            RESPONSE_RESULT_MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), " RESPONSE_RESULT_MESSAGE", "resultMessage")
            log.info("Action data loaded: API_ENDPOINT={}, RETRY_DELAY_MS={},UNAUTHORIZED_RESULT_CODE={},SUCCESS_RESULT_CODE={}",
                    API_ENDPOINT, RETRY_DELAY_MS, UNAUTHORIZED_RESULT_CODE, SUCCESS_RESULT_CODE)
        }

        // Always set the transaction retry delay
        transaction.setDefaultRetryDelayMs(RETRY_DELAY_MS)
    }

    @Override
    protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException {
        super.evaluatePreConditions(transaction);
        handleDependentLinkActions(transaction)
    }

    @Override
    protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.info("No validation defined for requestId: ${transaction.inboundRequest.id} with inboundTxnId: ${transaction.inboundRequest.inboundTxnId}")
    }

    @Override
    protected void createRequest(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Started creation of request for requestId: ${transaction.inboundRequest.id} with inboundTxnId: ${transaction.inboundRequest.inboundTxnId}")
        try {
            String xmlRequest = createXmlRequest(transaction.inboundRequest.payload,
                    commonUtils.getSystemToken(transaction.inboundRequest.token),
                    transaction.inboundRequest.operationType)
            transaction.linkActionInProgress.request = xmlRequest
            log.info("Created XML request: ${xmlRequest}")
        } catch (Exception e) {
            log.error("Failed to create XML request", e)
            throw new ActionProcessingException("Failed to create XML request: ${e.message}")
        }
    }

    @Override
    protected void makeApiCall(HelperTransaction transaction) throws RetriableException {
        String xmlRequest = transaction.linkActionInProgress.request
        HttpEntity<String> requestEntity = buildHttpEntity(xmlRequest, transaction.inboundRequest.token)
        try
        {
        String response = restTemplate.postForObject(API_ENDPOINT, requestEntity, String)
        transaction.linkActionInProgress.response = response
        log.info("Received response: ${response}")
        }
        catch (Exception e)
        {
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL);
            log.error("Failed to make API call", e);
            throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL);
        }
    }

    @Override
    protected void handleResponse(HelperTransaction transaction) throws ActionProcessingException {
        String response = transaction.linkActionInProgress.response
        if(!response) {
            throw new ActionProcessingException("ERROR_EMPTY_RESPONSE")
        }
        Document doc = commonUtils.parseXml(response)
        Element rootElement = doc.documentElement
        if(rootElement.nodeName == RESPONSE_BASERESPONSE) {
            String resultCode = rootElement.getElementsByTagName(RESPONSE_RESULT_CODE).item(0).textContent
            if(resultCode == UNAUTHORIZED_RESULT_CODE){
                String resultMessage = rootElement.getElementsByTagName(RESPONSE_RESULT_MESSAGE).item(0).textContent
                throw new ActionProcessingException(resultMessage)
            }
        } else if(rootElement.nodeName == RESPONSE_COMMAND){
            String txnCode = rootElement.getElementsByTagName(RESPONSE_TXN_STATUS).item(0).textContent
            if(txnCode != SUCCESS_RESULT_CODE){
                throw new ActionProcessingException(rootElement.getElementsByTagName(RESPONSE_MESSAGE).item(0).textContent)
            }
        }
    }

    @Override
    protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
        log.debug("Extracted action data map: {}", transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy());
    }

    @Override
    protected void callback(HelperTransaction transaction) throws ActionProcessingException {
        log.info("Started callback for requestId: ${transaction.inboundRequest.id} with inboundTxnId: ${transaction.inboundRequest.inboundTxnId}")
        String response = transaction.linkActionInProgress.response
        log.debug("Received response: ${response}")
    }

    private HttpEntity<String> buildHttpEntity(String xmlRequest, String systemToken) {
        def headers = new HttpHeaders()
        headers.contentType = MediaType.APPLICATION_XML
        headers.set("system-token", systemToken)
        return new HttpEntity<>(xmlRequest, headers)
    }

    private String createXmlRequest(Object payload, SystemToken systemToken, String operationType) throws Exception {
        def payloadMap = commonUtils.convertObjectToMap(payload.toString())
        def resellerInfoMap = commonUtils.convertObjectToMap(payloadMap.get("reseller"))
        def dynamicDataMap = commonUtils.convertObjectToMap(resellerInfoMap.get("dynamicData"))
        def extraParamMap = commonUtils.convertObjectToMap(
                commonUtils.convertObjectToMap(resellerInfoMap.get("extraParams")).get("parameters"))
        def addressMap = commonUtils.convertObjectToMap(resellerInfoMap.get("address"))

        Document doc = actionHelperUtils.getDocumentBuilder().newDocument()
        Element commandElement = createCommandElement(doc, systemToken)
        createDataElement(doc, commandElement, resellerInfoMap, operationType)
        return actionHelperUtils.transformToString(doc)
    }

    private Element createCommandElement(Document doc, SystemToken systemToken) {
        Element commandElement = doc.createElement("COMMAND")
        doc.appendChild(commandElement)

        actionHelperUtils.addElement(doc, commandElement, "TYPE", "USERSRREQ")
        actionHelperUtils.addElement(doc, commandElement, "Date", commonUtils.convertTimestampToDate(systemToken.startTime, "dd/MM/yyyy"))
        actionHelperUtils.addElement(doc, commandElement, "EXTNWCODE", "BD")
        actionHelperUtils.addElement(doc, commandElement, "EMPCODE", null)
        actionHelperUtils.addElement(doc, commandElement, "LOGINID", "OPERATOR")
        actionHelperUtils.addElement(doc, commandElement, "PASSWORD", "Seamless@1234")
        actionHelperUtils.addElement(doc, commandElement, "MSISDN", null)
        actionHelperUtils.addElement(doc, commandElement, "PIN", null)
        actionHelperUtils.addElement(doc, commandElement, "EXTREFNUM", systemToken.ersReference)

        return commandElement
    }

    private void createDataElement(Document doc, Element commandElement,
                                   Map<String, Object> resellerInfoMap, String operationType) throws ActionProcessingException {
        Element dataElement = doc.createElement("DATA")
        commandElement.appendChild(dataElement)

        actionHelperUtils.addElement(doc, dataElement, "USERMSISDN", actionHelperUtils.getMapValue(resellerInfoMap, "resellerMSISDN", true, ""))
        actionHelperUtils.addElement(doc, dataElement, "USERORIGINID", actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, ""))
        actionHelperUtils.addElement(doc, dataElement, "USERLOGINID", actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, ""))
        actionHelperUtils.addElement(doc, dataElement, "EXTERNALCODE", null)
        switch(operationType) {
            case "blockedReseller":
                actionHelperUtils.addElement(doc, dataElement, "ACTION", "S")
                break
            case "unBlockedReseller":
                actionHelperUtils.addElement(doc, dataElement, "ACTION", "R")
                break
            default:
                throw new ActionProcessingException("Invalid operation type: " + operationType)
        }
    }
}