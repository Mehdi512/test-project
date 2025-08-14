package se.seamless.idm.actions.impl

import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.databind.JsonNode
import com.seamless.common.transaction.SystemToken
import groovy.transform.CompileStatic
import org.apache.commons.lang3.StringUtils
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.http.HttpStatus
import org.springframework.http.RequestEntity
import org.springframework.http.ResponseEntity
import org.springframework.http.client.ClientHttpRequest
import org.springframework.stereotype.Component
import org.springframework.util.MultiValueMap
import org.springframework.web.client.HttpClientErrorException
import org.springframework.web.client.HttpServerErrorException
import org.springframework.web.client.RequestCallback
import org.springframework.web.client.ResponseExtractor
import org.springframework.web.client.RestTemplate
import org.w3c.dom.Document
import org.w3c.dom.Element
import se.seamless.idm.entity.LinkActionErrorReason
import se.seamless.idm.enums.LinkActionStatus
import se.seamless.idm.exceptions.ActionProcessingException
import se.seamless.idm.exceptions.SkippableActionException
import se.seamless.idm.model.HelperTransaction
import se.seamless.idm.actions.AbstractAction
import se.seamless.idm.util.CommonUtils

import javax.validation.constraints.NotBlank
import javax.validation.constraints.NotNull
import javax.xml.transform.dom.DOMSource
import javax.xml.transform.stream.StreamResult

class ERS_WITHDRAWL_TASK extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(ERS_WITHDRAWL_TASK.class)
    private static final String TRANSFER_URL = "http://svc-idm-ers-link:15500/erslink/v1/endpoint"
    private static final String ERS_URL = "http://{{ .Values.HOST__link_simulator }}:{{ .Values.PORT__link_simulator }}/restservice/api/standard-link/gp/endPoint?LOGIN=Dms&PASSWORD=27ad2f57a08b558b&REQUEST_GATEWAY_CODE=DMS&REQUEST_GATEWAY_TYPE=EXTGW&SERVICE_PORT=190&SOURCE_TYPE=EXTGW"
    private static final String TASK = ERS_WITHDRAWL_TASK.class.name

    @Override
    void evaluatePreConditions(HelperTransaction transaction) {
        log.info("{} - Checking preconditions for requestId: {} with inboundTxnId: {}", TASK,
                transaction.inboundRequest.inboundTxnId,
                transaction.inboundRequest.inboundTxnId)
        try {
        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }

    @Override
    void validateRequest(HelperTransaction transaction) {
        log.info("{} implementation - Validating request for requestId: {} with inboundTxnId: {}", TASK,
                transaction.inboundRequest.inboundTxnId,
                transaction.inboundRequest.inboundTxnId)
        try {
        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }

    @Override
    void createRequest(HelperTransaction transaction) {
        log.info("{} implementation - Creating request for requestId: {} with inboundTxnId: {}", TASK,
                transaction.inboundRequest.inboundTxnId,
                transaction.inboundRequest.inboundTxnId)
        try {
            String payload = transaction.inboundRequest.payload
            Payload request = gson.fromJson(payload, Payload.class)
            log.info("ERS WITHDRAW REQUEST: {}", request.ERSWITHDRAW)
            if (request.ERSWITHDRAW) {
                String xmlRequest = createXmlRequest(request.ERSWITHDRAW[0],
                        commonUtils.getSystemToken(transaction.inboundRequest.token))
                log.debug("Created XML request: {}", xmlRequest)
                transaction.linkActionInProgress.request = xmlRequest
            } else {
                log.info("\n ==================\n NO ERS WITHDRAWS IN REQUEST TO PROCESS for requestId: [{}] - inboundTxnId: [{}]\n ==================",
                        transaction.inboundRequest.inboundTxnId,
                        transaction.inboundRequest.inboundTxnId)
                throw new SkippableActionException("NO ERS WITHDRAWS IN REQUEST TO PROCESS", LinkActionStatus.SKIPPED)
            }
        } catch (InterruptedException | SkippableActionException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        } catch (Exception e) {
            throw new RuntimeException(e)
        }
    }

    @Override
    void makeApiCall(HelperTransaction transaction) {
        log.info("{} implementation - Making API call for requestId: {} with inboundTxnId: {}", TASK,
                transaction.inboundRequest.inboundTxnId,
                transaction.inboundRequest.inboundTxnId)
        try {
            transaction.externalCallSuccess = false
            String xmlRequest = transaction.linkActionInProgress.request
            String systemToken = transaction.inboundRequest.token
            String authorization = transaction.inboundRequest.authorization
            HttpHeaders headers = getHttpHeaders(systemToken, authorization)
            headers.set("accept", "application/xml")
            headers.set("Content-Type", "application/xml")
            headers.set("url", ERS_URL)
            HttpEntity<String> requestEntity = new HttpEntity<>(xmlRequest, headers)
            ResponseEntity<String> responseEntity = restTemplate.exchange(TRANSFER_URL, HttpMethod.POST, requestEntity, String.class)
            if (responseEntity.statusCode == HttpStatus.OK) {
                transaction.externalCallSuccess = true
                transaction.linkActionInProgress.response = responseEntity.body
            } else {
                transaction.externalCallResultDescription = "API Call returned non-200 response code"
                throw new ActionProcessingException("API Call returned non-200 response code")
            }
        } catch (Exception e) {
            LinkActionErrorReason errorReason = new LinkActionErrorReason()
            errorReason.linkAction = transaction.linkActionInProgress
            if (e instanceof HttpClientErrorException) {
                log.warn("HTTP Client Exception - Check request")
                errorReason.reason = "HTTP Client Exception - Check request"
            } else if (e instanceof HttpServerErrorException) {
                log.error("HttpServerErrorException exception", e)
                errorReason.reason = "HttpServerErrorException exception"
            } else if (e instanceof ActionProcessingException) {
                log.error(e.message, e)
                errorReason.reason = e.message
            } else {
                log.error("Unexpected exception ", e)
                errorReason.reason = "Unexpected exception: ${e.message}"
            }
            linkActionErrorReasonService.save(errorReason)
            transaction.linkActionInProgress.status = LinkActionStatus.FAILED_AT_API_CALL
            throw e
        }
    }

    @Override
    void handleResponse(HelperTransaction transaction) {
        log.info("{} implementation - Parsing response for requestId: {} with inboundTxnId: {}", TASK,
                transaction.inboundRequest.inboundTxnId,
                transaction.inboundRequest.inboundTxnId)
        String response = transaction.linkActionInProgress.response
        if (!response) {
            throw new ActionProcessingException("Received empty response")
        }
        Document doc = commonUtils.parseXml(response)
        Element rootElement = doc.documentElement
        if (rootElement.nodeName == "BaseResponse") {
            String resultCode = rootElement.getElementsByTagName("resultCode").item(0).textContent
            if (resultCode == "401") {
                String resultMessage = rootElement.getElementsByTagName("resultMessage").item(0).textContent
                throw new ActionProcessingException(resultMessage)
            }
            transaction.externalCallSuccess = true
        } else if (rootElement.nodeName == "COMMAND") {
            String txnCode = rootElement.getElementsByTagName("TXNSTATUS").item(0).textContent
            if (txnCode != "200") {
                throw new ActionProcessingException(rootElement.getElementsByTagName("MESSAGE").item(0).textContent)
            }
            transaction.externalCallSuccess = true
        }
    }

    @Override
    void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
    }

    @Override
    void callback(HelperTransaction transaction) {
        // Callback disabled
    }

    private String createXmlRequest(WithdrawRequest withdrawRequest, SystemToken systemToken) throws Exception {
        Document doc = actionHelperUtils.documentBuilder.newDocument()
        createCommandElement(doc, systemToken, withdrawRequest)
        return actionHelperUtils.transformToString(doc)
    }

    private static void createCommandElement(Document doc, SystemToken systemToken, WithdrawRequest withdrawRequest) {
        Element commandElement = doc.createElement("COMMAND")
        doc.appendChild(commandElement)

        addElement(doc, commandElement, "TYPE", "O2CWDREQ")
        addElement(doc, commandElement, "EXTNWCODE", "BD")
        addElement(doc, commandElement, "MSISDN", withdrawRequest.command.msisdn)
        addElement(doc, commandElement, "PIN", withdrawRequest.command.pin)
        addElement(doc, commandElement, "EXTCODE",
                StringUtils.isNotBlank(withdrawRequest.command.extcode) ?
                        withdrawRequest.command.extcode : "")
        createProductElement(doc, commandElement, withdrawRequest)
        addElement(doc, commandElement, "EXTTXNNUMBER", withdrawRequest.command.exttxnnumber)
        addElement(doc, commandElement, "EXTTXNDATE", withdrawRequest.command.exttxndate)
        addElement(doc, commandElement, "REMARKS", "O2C Withdraw")
    }

    private static void createProductElement(Document doc, Element commandElement, WithdrawRequest withdrawRequest) {
        Element productsElement = doc.createElement("PRODUCTS")
        commandElement.appendChild(productsElement)

        addElement(doc, productsElement, "PRODUCTCODE", withdrawRequest.command.products.productcode)
        addElement(doc, productsElement, "QTY", withdrawRequest.command.products.qty)
    }

    static void addElement(Document doc, Element parent, String name, String value) {
        Element element = doc.createElement(name)
        element.textContent = value
        parent.appendChild(element)
    }

    private static HttpHeaders getHttpHeaders(String systemToken, String authorization) {
        authorization = StringUtils.isBlank(authorization) ? "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9" : authorization
        log.debug("System-Token : {}", systemToken)
        log.debug("authorization : {}", authorization)

        HttpHeaders headers = new HttpHeaders()
        headers.set("accept", "application/json")
        headers.set("system-token", systemToken)
        headers.set("authorization", authorization)

        return headers
    }

    String transformToString(Document doc) throws Exception {
        StringWriter writer = new StringWriter()
        actionHelperUtils.transformer.transform(new DOMSource(doc), new StreamResult(writer))
        return writer.toString()
    }

    static class Payload {
        WithdrawRequest[] ERSWITHDRAW

        @Override
        String toString() {
            "Payload{ERSWITHDRAW=${ERSWITHDRAW}}"
        }
    }

    static class WithdrawRequest {
        RequestCommand command

        @Override
        String toString() {
            "WithdrawRequest{command=${command}}"
        }
    }

    static class RequestCommand {
        String type
        String extnwcode
        String msisdn
        String pin
        String extcode
        String exttxnnumber
        String exttxndate
        Product products
        String remarks

        @Override
        String toString() {
            "RequestCommand{type='${type}', extnwcode='${extnwcode}', msisdn='${msisdn}', pin='${pin}', extcode='${extcode}', exttxnnumber='${exttxnnumber}', exttxndate='${exttxndate}', products=${products}, remarks='${remarks}'}"
        }
    }

    static class Product {
        String productcode
        String qty

        @Override
        String toString() {
            "Product{productcode='${productcode}', qty='${qty}'}"
        }
    }

    static class WithdrawResponse {
        ResponseCommand COMMAND

        @Override
        String toString() {
            "WithdrawResponse{COMMAND=${COMMAND}}"
        }
    }

    static class ResponseCommand {
        String DATE
        String MESSAGE
        String EXTTXNNUMBER
        String TYPE
        String TXNID
        String TXNSTATUS

        @Override
        String toString() {
            "ResponseCommand{DATE='${DATE}', MESSAGE='${MESSAGE}', EXTTXNNUMBER='${EXTTXNNUMBER}', TYPE='${TYPE}', TXNID='${TXNID}', TXNSTATUS='${TXNSTATUS}'}"
        }
    }

    static class BaseResponse {
        String ersReference
        int resultCode
        String resultMessage

        @Override
        String toString() {
            "BaseResponse{ersReference='${ersReference}', resultCode=${resultCode}, resultMessage='${resultMessage}'}"
        }
    }
}