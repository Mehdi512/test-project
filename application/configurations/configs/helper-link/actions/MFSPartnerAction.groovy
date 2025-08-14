package se.seamless.idm.actions.impl;

import com.seamless.common.transaction.SystemToken;
import groovy.transform.CompileStatic;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import se.seamless.idm.actions.AbstractAction;
import se.seamless.idm.enums.LinkActionStatus;
import se.seamless.idm.exceptions.ActionProcessingException;
import se.seamless.idm.exceptions.PayloadParsingException;
import se.seamless.idm.exceptions.RetriableException;
import se.seamless.idm.exceptions.SkippableActionException;
import se.seamless.idm.model.HelperTransaction;

import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.StringWriter;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicBoolean

@CompileStatic
class MFSPartnerAction extends AbstractAction
{
    private static final Logger log = LoggerFactory.getLogger(MFSPartnerAction.class);

    private final AtomicBoolean initialized = new AtomicBoolean(false)

    private String API_ENDPOINT
    private String SUCCESS_RESULT_CODE
    private String RESPONSE_BASERESPONSE
    private String RESPONSE_COMMAND
    private String RESPONSE_TXN_STATUS
    private String RESPONSE_MESSAGE
    private String RESPONSE_RESULT_CODE
    private String RESPONSE_RESULT_MESSAGE
    private List<String> RETRIABLE_STATUS_CODES
    private int RETRY_DELAY_MS
    

    @Override
    protected void loadActionData(HelperTransaction transaction) {
        // Only load data once per instance
        if (!initialized.getAndSet(true)) {
            log.info("Initializing ActionData for MFSPartnerAction bean")
            API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-idm-mfs-link:15600/mfslink/v1/transfer-request")
            SUCCESS_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "SUCCESS_RESULT_CODE", "200")
            RESPONSE_BASERESPONSE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_BASERESPONSE", "BaseResponse")
            RESPONSE_COMMAND = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_COMMAND", "COMMAND")
            RESPONSE_TXN_STATUS = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_TXN_STATUS", "TXNSTATUS")
            RESPONSE_MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_MESSAGE", "MESSAGE")
            RESPONSE_RESULT_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_RESULT_CODE", "resultCode")
            RESPONSE_RESULT_MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RESPONSE_RESULT_MESSAGE", "resultMessage")
            RETRIABLE_STATUS_CODES = actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "RETRIABLE_STATUS_CODES", Arrays.asList("500", "400"))
            RETRY_DELAY_MS = actionDataUtils.getActionDataInteger(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", transaction.getDefaultRetryDelayMs())
            log.info("Action Data loaded: API_ENDPOINT: {}, SUCCESS_RESULT_CODE: {}, RESPONSE_BASERESPONSE: {}, RESPONSE_COMMAND: {}, RESPONSE_TXN_STATUS: {}, RESPONSE_MESSAGE: {}, RESPONSE_RESULT_CODE: {}, RESPONSE_RESULT_MESSAGE: {}, RETRIABLE_STATUS_CODES: {}, RETRY_DELAY_MS: {}",
                    API_ENDPOINT, SUCCESS_RESULT_CODE, RESPONSE_BASERESPONSE, RESPONSE_COMMAND, RESPONSE_TXN_STATUS, RESPONSE_MESSAGE, RESPONSE_RESULT_CODE, RESPONSE_RESULT_MESSAGE, RETRIABLE_STATUS_CODES, RETRY_DELAY_MS)
        }

        // Always set the transaction retry delay
        transaction.setDefaultRetryDelayMs(RETRY_DELAY_MS)
    }


    @Override
    protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException, SkippableActionException
    {
        super.evaluatePreConditions(transaction);
        log.debug("No pre-conditions defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId());
    }

    @Override
    protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException
    {
        log.info("No validation defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
    }

    @Override
    protected void createRequest(HelperTransaction transaction) throws ActionProcessingException
    {
        log.info("Started creation of request for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
        try
        {
            String xmlRequest = createXmlRequest(transaction.getInboundRequest().getPayload(),
                    transaction,
                    commonUtils.getSystemToken(transaction.getInboundRequest().getToken()));
            transaction.getLinkActionInProgress().setRequest(xmlRequest);
            log.debug("Created XML request: {}", xmlRequest);
        }
        catch (Exception e)
        {
            log.error("Failed to create XML request", e);
            throw new ActionProcessingException("Failed to create XML request: " + e.getMessage());
        }
    }

    @Override
    protected void handleResponse(HelperTransaction transaction) throws ActionProcessingException, PayloadParsingException, RetriableException
    {
        String response = transaction.getLinkActionInProgress().getResponse();
        if (response == null || response.isEmpty())
        {
            throw new ActionProcessingException("ERROR_EMPTY_RESPONSE");
        }
        Document doc = commonUtils.parseXml(response);
        Element baseResponse = doc.getDocumentElement();

        if (baseResponse.getNodeName().equals(RESPONSE_BASERESPONSE))
        {
            String resultCode = baseResponse.getElementsByTagName(RESPONSE_RESULT_CODE).item(0).getTextContent();
            if (RETRIABLE_STATUS_CODES.contains(resultCode))
            {
                String resultMessage = baseResponse.getElementsByTagName(RESPONSE_RESULT_MESSAGE).item(0).getTextContent();
                throw new RetriableException(resultMessage, LinkActionStatus.FAILED_AT_HANDLE_RESPONSE);
            }
        }
        else if (baseResponse.getNodeName().equals(RESPONSE_COMMAND))
        {
            String txnCode = baseResponse.getElementsByTagName(RESPONSE_TXN_STATUS).item(0).getTextContent();
            if (!(SUCCESS_RESULT_CODE.equals(txnCode)))
            {
                throw new ActionProcessingException(baseResponse.getElementsByTagName(RESPONSE_MESSAGE).item(0).getTextContent());
            }
        }
    }

    @Override
    protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException
    {
        String action = transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy();
        log.debug("Extracted action data map: {}", action);
    }

    @Override
    protected void makeApiCall(HelperTransaction transaction) throws RetriableException
    {
        String xmlRequest = transaction.getLinkActionInProgress().getRequest();
        String bearerAuthToken = "U0VBTUxFU1M6M3F6ajY1a0w=";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_XML);
        headers.set("system-token", transaction.getInboundRequest().getToken());
        headers.setBearerAuth(bearerAuthToken);
        HttpEntity<String> requestEntity = new HttpEntity<>(xmlRequest, headers);
        try
        {
          String response = restTemplate.postForObject(API_ENDPOINT, requestEntity, String.class);
          transaction.getLinkActionInProgress().setResponse(response);
          log.debug("Received response: {}", response);
        }
        catch (Exception e)
        {
          transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL);
          log.error("Failed to make API call", e);
          throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL);
        }
    }

    private String createXmlRequest(Object payload, HelperTransaction transaction, SystemToken systemToken) throws Exception
    {
        Map<String, Object> payloadMap = commonUtils.convertObjectToMap(payload.toString());
        Map<String, Object> resellerInfoMap = commonUtils.convertObjectToMap(payloadMap.get("reseller"));
        Document doc = actionHelperUtils.getDocumentBuilder().newDocument();

        // Create root element
        Element commandElement = doc.createElement("COMMAND");
        doc.appendChild(commandElement);

        // Add elements
        String type = transformToChangeType(transaction.getInboundRequest().getOperationType());
        actionHelperUtils.addElement(doc, commandElement, "TYPE", type);
        actionHelperUtils.addElement(doc, commandElement, "PROVIDER", "101");
        actionHelperUtils.addElement(doc, commandElement, "MSISDN", actionHelperUtils.getMapValue(resellerInfoMap, "resellerMSISDN", true, ""));
        actionHelperUtils.addElement(doc, commandElement, "DMSTXNID", systemToken.getErsReference());
        actionHelperUtils.addElement(doc, commandElement, "REASON", "testing");
        actionHelperUtils.addElement(doc, commandElement, "SESSION_ID", systemToken.getErsReference());
        actionHelperUtils.addElement(doc, commandElement, "TRID", systemToken.getErsReference());

        StringWriter writer = new StringWriter();
        actionHelperUtils.getTransformer().transform(new DOMSource(doc), new StreamResult(writer));

        return writer.toString();
    }

    private String transformToChangeType(String operationType) throws ActionProcessingException
    {
        switch (operationType)
        {
            case "blockedReseller":
                return "REQSUCH";
            case "unBlockedReseller":
                return "REQRCH";
            case "deActivateReseller":
                return "REQDBCH";
            default:
                throw new ActionProcessingException("Invalid operation type: " + operationType);
        }
    }

    @Override
    protected void callback(HelperTransaction transaction) throws ActionProcessingException
    {
        log.debug(
                "No callback defined for requestId: {} with inboundTxnId: {}",
                transaction.getInboundRequest().getId(),
                transaction.getInboundRequest().getInboundTxnId());
    }
}