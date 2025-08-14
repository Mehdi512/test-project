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
import se.seamless.idm.exceptions.ActionProcessingException
import se.seamless.idm.exceptions.RetriableException
import se.seamless.idm.model.HelperTransaction
import com.fasterxml.jackson.core.type.TypeReference
import com.fasterxml.jackson.databind.ObjectMapper
import java.util.concurrent.atomic.AtomicBoolean

import javax.xml.parsers.DocumentBuilder
import javax.xml.parsers.DocumentBuilderFactory
import java.nio.charset.StandardCharsets
import java.util.Arrays
import java.util.HashMap
import java.util.HashSet
import java.util.Map
import java.util.Objects
import java.util.Set
import java.lang.Integer

@CompileStatic
class MFSBalanceEnquiryAction extends AbstractAction
{
    private static final Logger log = LoggerFactory.getLogger(MFSBalanceEnquiryAction.class);

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
            log.info("Loading action data for MFSBalanceEnquiryAction, requestId: {}", transaction.getInboundRequest().getId());
            API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-idm-mfs-link:15600/mfslink/v1/transfer-request");
            RETRY_DELAY_MS = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", "1000");
            STATUS_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "STATUS_CODE", "txnstatus");
            MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "MESSAGE", "message");
            LIMIT_DYNAMIC_DATA = actionDataUtils.getActionDataBoolean(transaction.getLinkActionInProgress(), "LIMIT_DYNAMIC_DATA", true);
            RETRIABLE_STATUS_CODES = actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "RETRIABLE_STATUS_CODES", Arrays.asList("500", "400"));
            log.info("Action data loaded: API_ENDPOINT={}, RETRY_DELAY_MS={}, STATUS_CODE={}, MESSAGE={}, RETRIABLE_STATUS_CODES={}",
                    API_ENDPOINT, RETRY_DELAY_MS, STATUS_CODE, MESSAGE, RETRIABLE_STATUS_CODES);
        }
        transaction.setDefaultRetryDelayMs(Integer.parseInt(RETRY_DELAY_MS));
    }

    @Override
    protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException {
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

        String response = restTemplate.postForObject(API_ENDPOINT, requestEntity, String.class);
        transaction.getLinkActionInProgress().setResponse(response);
        log.debug("Received response: {}", response);
    }

    @Override
    protected void handleResponse(HelperTransaction transaction) throws ActionProcessingException {
        String response = transaction.getLinkActionInProgress().getResponse();
        if(response == null || response.isEmpty())
        {
            throw new ActionProcessingException("Received empty response");
        }
        Document doc = commonUtils.parseXml(response);
        Element rootElement = doc.getDocumentElement();
        if(rootElement.getNodeName().equals("BaseResponse"))
        {
            String resultCode = rootElement.getElementsByTagName("resultCode").item(0).getTextContent();
            if(resultCode.equals("401"))
            {
                String resultMessage = rootElement.getElementsByTagName("resultMessage").item(0).getTextContent();
                throw new ActionProcessingException(resultMessage);
            }
        }
        else if(rootElement.getNodeName().equals("COMMAND"))
        {
            String txnCode = rootElement.getElementsByTagName("TXNSTATUS").item(0).getTextContent();
            if(!txnCode.equals("200"))
            {
                throw new ActionProcessingException(rootElement.getElementsByTagName("MESSAGE").item(0).getTextContent());
            }
        }
    }

    @Override
    protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
        String action = transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy();
        Map<String, Object> actionDataMap = transaction.getActionResponseData().get(action);
        Document doc = commonUtils.parseXml(transaction.getLinkActions().get(0).getResponse());
        Element rootElement = doc.getDocumentElement();

        if(!rootElement.getNodeName().equals("COMMAND"))
        {
            log.error("No action data map found for action: {}", action);
            throw new ActionProcessingException("No action data map found for action: " + action);
        }

        actionDataMap.put("type", resolveElementValue(rootElement, "TYPE"));
        actionDataMap.put("txnId", resolveElementValue(rootElement, "TXNID"));
        actionDataMap.put(STATUS_CODE, resolveElementValue(rootElement, "TXNSTATUS"));
        actionDataMap.put(MESSAGE, resolveElementValue(rootElement, "MESSAGE"));
        actionDataMap.put("resultCode", resolveElementValue(rootElement, "TXNSTATUS"));
        actionDataMap.put("resultMessage", resolveElementValue(rootElement, "MESSAGE"));
        actionDataMap.put("trId", resolveElementValue(rootElement, "TRID"));
        actionDataMap.put("balance", resolveElementValue(rootElement, "BALANCE"));

        log.debug("Extracted action data map: {}", actionDataMap);
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

        Document doc = actionHelperUtils.getDocumentBuilder().newDocument();
        Element commandElement = createCommandElement(operationType, doc, systemToken, payloadMap);

        return actionHelperUtils.transformToString(doc);
    }

    private Element createCommandElement(String operationType, Document doc, SystemToken systemToken, Map<String, Object> payloadMap) {
        Element commandElement = doc.createElement("COMMAND");
        doc.appendChild(commandElement);

        ObjectMapper mapper = new ObjectMapper();

        actionHelperUtils.addElement(doc, commandElement, "TYPE", "RBEREQ");

        String pin = actionHelperUtils.getMapValue(payloadMap, "pin", true, "");
        String decodedPin = decodeBase64Encoded(pin)

        String msisdn = actionHelperUtils.getMapValue(payloadMap, "msisdn", true, "");

        actionHelperUtils.addElement(doc, commandElement, "PIN", decodedPin);
        actionHelperUtils.addElement(doc, commandElement, "MSISDN", msisdn);
        actionHelperUtils.addElement(doc, commandElement, "PROVIDER", "101");
        actionHelperUtils.addElement(doc, commandElement, "PAYID", "12");
        actionHelperUtils.addElement(doc, commandElement, "LANGUAGE1", "1");
        actionHelperUtils.addElement(doc, commandElement, "SESSION_ID", systemToken.getErsReference());
        actionHelperUtils.addElement(doc, commandElement, "TRID", systemToken.getErsReference());


        return commandElement;
    }

    private String decodeBase64Encoded(String encodedString) {
        byte[] decodedBytes = Base64.getDecoder().decode(encodedString);
        return new String(decodedBytes, StandardCharsets.UTF_8);
    }

    private String resolveElementValue(Element element, String keyName) {
        return element.getElementsByTagName(keyName).item(0).getTextContent();
    }
}