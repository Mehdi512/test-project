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
class ERS_TRANSFER_TASK extends AbstractAction {

    private static final Logger log = LoggerFactory.getLogger(ERS_TRANSFER_TASK.class)

    private static final String transferUrl = "http://svc-idm-ers-link:15500/erslink/v1/endpoint"
    private static final String callbackUrl = "http://svc-order-management:9595/oms/v2/ext/order"
    private static final String ersUrl = "http://{{ .Values.HOST__link_simulator }}:{{ .Values.PORT__link_simulator }}/restservice/api/standard-link/gp/endPoint?LOGIN=Dms&PASSWORD=27ad2f57a08b558b&REQUEST_GATEWAY_CODE=DMS&REQUEST_GATEWAY_TYPE=EXTGW&SERVICE_PORT=190&SOURCE_TYPE=EXTGW"

    private static final String TASK = ERS_TRANSFER_TASK.class.name


    @Override
    void evaluatePreConditions(HelperTransaction transaction) {
        log.info("{} - Checking preconditions for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
        try {

        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }

    @Override
    void validateRequest(HelperTransaction transaction) {
        log.info("{} implementation - Validating request for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
        try {
        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }



    @Override
    void createRequest(HelperTransaction transaction) {
        log.info("{} implementation - Creating request for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            String payload = transaction.getInboundRequest().getPayload()
            Payload request = gson.fromJson(payload, Payload.class)
            log.info("ERS TRANSFER REQUEST: {}", request.ERSTRANSFER)
            if(request.ERSTRANSFER != null)
            {
                String xmlRequest = createXmlRequest(request.ERSTRANSFER[0], commonUtils.getSystemToken(transaction.getInboundRequest().getToken()))
                log.debug("Created XML request: {}", xmlRequest)
                transaction.getLinkActionInProgress().setRequest(xmlRequest)
            }
            else
            {
                log.info("\n ==================\n NO ERS TRANSFERS IN REQUEST TO PROCESS for requestId: [{}] - inboundTxnId: [{}]\n ==================", transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
                throw new SkippableActionException("NO ERS TRANSFERS IN REQUEST TO PROCESS", LinkActionStatus.SKIPPED)

            }


        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }

    @Override
    void makeApiCall(HelperTransaction transaction) {
        log.info("{} implementation - Making API call for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
        try {

            transaction.setExternalCallSuccess(false)
            String xmlRequest = transaction.getLinkActionInProgress().getRequest()
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()
            HttpHeaders headers = getHttpHeaders(systemToken, authorization)
            headers.set("accept", "application/xml")
            headers.set("Content-Type", "application/xml")
            headers.set("url", ersUrl)
            HttpEntity<String> requestEntity = new HttpEntity<>(xmlRequest, headers)
            ResponseEntity<String> responseEntity  = restTemplate.exchange(transferUrl, HttpMethod.POST, requestEntity, String.class)
            if(responseEntity.statusCode == HttpStatus.OK){
                transaction.setExternalCallSuccess(true)
                transaction.getLinkActionInProgress().setResponse(responseEntity.getBody())
            } else {
                transaction.setExternalCallResultDescription("API Call returned non-200 response code")
                throw new ActionProcessingException("API Call returned non-200 response code")
            }

        } catch(Exception e){
            LinkActionErrorReason errorReason = new LinkActionErrorReason()
            errorReason.setLinkAction(transaction.getLinkActionInProgress())
            if(e instanceof HttpClientErrorException){
                log.warn("HTTP Client Exception -  Check request")
                errorReason.setReason("HTTP Client Exception -  Check request")
            } else if (e instanceof HttpServerErrorException){
                log.error("HttpServerErrorException exception", e)
                errorReason.setReason("HttpServerErrorException exception")
            } else if (e instanceof ActionProcessingException) {
                log.error(e.getMessage(), e)
                errorReason.setReason(e.getMessage())
            }
            else {
                log.error("Unexpected exception ", e)
                errorReason.setReason("Unexpected exception: " + e.getMessage())
            }
            linkActionErrorReasonService.save(errorReason)
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL)
            throw e
        }

    }

    @Override
    void handleResponse(HelperTransaction transaction) {
        log.info("{} implementation - Parsing response for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())


        String response = transaction.getLinkActionInProgress().getResponse()
        if(response == null || response.isEmpty()){
            throw new ActionProcessingException("Received empty response")
        }
        Document doc = commonUtils.parseXml(response)
        Element rootElement = doc.getDocumentElement()
        if(rootElement.getNodeName() =="BaseResponse") {
            String resultCode = rootElement.getElementsByTagName("resultCode").item(0).getTextContent()
            if(resultCode == "401"){
                String resultMessage = rootElement.getElementsByTagName("resultMessage").item(0).getTextContent()
                throw new ActionProcessingException(resultMessage)
            }
            transaction.setExternalCallSuccess(true)
        } else if(rootElement.getNodeName() == "COMMAND"){
            String txnCode = rootElement.getElementsByTagName("TXNSTATUS").item(0).getTextContent()
            if(txnCode != "200"){
                throw new ActionProcessingException(rootElement.getElementsByTagName("MESSAGE").item(0).getTextContent())
            }
            transaction.setExternalCallSuccess(true)
        }
    }

    @Override
    void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
    }

    @Override
    void callback(HelperTransaction transaction) {
        log.info("{} implementation - Executing callback for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
        try {

            String payload = transaction.getInboundRequest().getPayload()
            Payload rawRequest = gson.fromJson(payload, Payload.class)

            TransferRequest[] requests = rawRequest.ERSTRANSFER
            TransferRequest request = requests[0]
            String requestId = transaction.getInboundRequest().getInboundTxnId()
            String inboundTxId = transaction.getInboundRequest().getInboundTxnId()
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()
            log.info("Request Type: [{}] for requestId: {} with inboundTxnId: {}", transaction.getInboundRequest().operationType, requestId, inboundTxId)
            log.info("Order ID: [{}] for requestId: {} with inboundTxnId: {}", request.command.refnumber, requestId, inboundTxId)
            log.info("External Call Success Status:  [{}] for requestId: {} with inboundTxnId: {}", transaction.isExternalCallSuccess(), requestId, inboundTxId)
            log.info("External Call Response Message: [{}] for requestId: {} with inboundTxnId: {}", transaction.getExternalCallResultDescription(), requestId, inboundTxId)
            log.debug("System token: {}", systemToken)
            log.info("Authorization: {}", authorization)

            if(transaction.isExternalCallSuccess())
            {
                ExtUpdateOrderRequest extUpdateOrderRequest = new ExtUpdateOrderRequest()
                extUpdateOrderRequest.operationId = ExtUpdateOrderOperation.TRANSFER_STATUS
                extUpdateOrderRequest.orderId = request.command.refnumber
                extUpdateOrderRequest.resellerId = request.command.extcode
                extUpdateOrderRequest.tokenObj = transaction.token
                extUpdateOrderRequest.searchOrderByInternalId = true
                extUpdateOrderRequest.externalActionResult = new ExternalActionResult()
                extUpdateOrderRequest.externalActionResult.transferResult = new TransferResult()
                extUpdateOrderRequest.externalActionResult.transferResult.resultCode = 0
                extUpdateOrderRequest.externalActionResult.transferResult.transferType = "ERS"
                extUpdateOrderRequest.externalActionResult.transferResult.isSuccess = Boolean.TRUE
                extUpdateOrderRequest.externalActionResult.transferResult.resultDescription = "SUCCESS"

                HttpHeaders headers = getHttpHeaders(systemToken, authorization)
                HttpEntity<ExtUpdateOrderRequest> extUpdateOrderRequestHttpEntity = new HttpEntity<>(extUpdateOrderRequest, headers)
                ResponseEntity<String> callbackResponse = restTemplate.exchange(callbackUrl, HttpMethod.PUT, extUpdateOrderRequestHttpEntity, String.class)
                if(callbackResponse.statusCode != HttpStatus.OK){
                    throw new ActionProcessingException("Callback returned non-200 response code")
                } else {
                    log.info("Callback response: {}",  callbackResponse.getBody())
                    BaseResponse response = gson.fromJson(callbackResponse.getBody(), BaseResponse.class)
                    if(response.resultCode != 0){
                        throw new ActionProcessingException("Callback returned non-zero response code")
                    }
                }

            }

        } catch (Exception e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
            LinkActionErrorReason errorReason = new LinkActionErrorReason()
            errorReason.setLinkAction(transaction.getLinkActionInProgress())
            errorReason.setReason(e.getMessage())
            linkActionErrorReasonService.save(errorReason)
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_CALLBACK)
            throw e
        }
    }

    private String createXmlRequest(TransferRequest transferRequest, SystemToken systemToken) throws Exception {
        Document doc = actionHelperUtils.getDocumentBuilder().newDocument()
        createCommandElement(doc, systemToken, transferRequest)
        return actionHelperUtils.transformToString(doc)
    }



    private static Element createCommandElement(Document doc, SystemToken systemToken, TransferRequest transferRequest) {
        Element commandElement = doc.createElement("COMMAND")
        doc.appendChild(commandElement)

        addElement(doc, commandElement, "TYPE", "O2CINTREQ")
        addElement(doc, commandElement, "EXTNWCODE", "BD")
        addElement(doc, commandElement, "MSISDN", transferRequest.command.msisdn)
        addElement(doc, commandElement, "USERORIGINID", "")
        addElement(doc, commandElement, "PIN", "MzgxMw==")
        addElement(doc, commandElement, "EXTCODE", com.seamless.common.StringUtils.isNotBlank(transferRequest.command.extcode) ? transferRequest.command.extcode : "")
        addElement(doc, commandElement, "EXTTXNDATE", transferRequest.command.exttxndate)
        addElement(doc, commandElement, "EXTTXNNUMBER", transferRequest.command.exttxnnumber)
//        addElement(doc, commandElement, "PIN", null)
//        addElement(doc, commandElement, "EXTREFNUM", systemToken.getErsReference())
        createProductElement(doc, commandElement, transferRequest)
        addElement(doc, commandElement, "TRFCATEGORY","SALE")
        addElement(doc, commandElement, "REFNUMBER",  transferRequest.command.refnumber)
        createPaymentDetailsElement(doc, commandElement, transferRequest)
        addElement(doc, commandElement, "PREFFEREDLANGUAGE",  "en")
        addElement(doc, commandElement, "REMARKS",  "O2C Direct Transfer")
        return commandElement
    }

    private static void createProductElement(Document doc, Element commandElement, TransferRequest transferRequest) {
        Element productsElement = doc.createElement("PRODUCTS")
        commandElement.appendChild(productsElement)

        addElement(doc, productsElement, "PRODUCTCODE", transferRequest.command.products.productcode)
        addElement(doc, productsElement, "QTY", transferRequest.command.products.qty)
    }

    private static void createPaymentDetailsElement(Document doc, Element commandElement, TransferRequest transferRequest) {
        Element productsElement = doc.createElement("PAYMENTDETAILS")
        commandElement.appendChild(productsElement)

        addElement(doc, productsElement, "PAYMENTTYPE", transferRequest.command.paymentdetails.paymenttype)
        addElement(doc, productsElement, "PAYMENTINSTNUMBER", transferRequest.command.paymentdetails.paymentinstnumber)
        addElement(doc, productsElement, "PAYMENTDATE", transferRequest.command.paymentdetails.paymentdate)
        addElement(doc, productsElement, "NETPAYABLEAMOUNT", transferRequest.command.paymentdetails.netpayableamount)
    }

    static void addElement(Document doc, Element parent, String name, String value) {
        Element element = doc.createElement(name)
        element.setTextContent(value)
        parent.appendChild(element)
    }


    private static HttpHeaders getHttpHeaders(String systemToken, String authorization)
    {
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
        actionHelperUtils.getTransformer().transform(new DOMSource(doc), new StreamResult(writer))
        return writer.toString()
    }

    static class Payload {
        TransferRequest[] ERSTRANSFER


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("Payload{")
            sb.append("ERSTRANSFER=").append(ERSTRANSFER)
            sb.append('}')
            return sb.toString()
        }
    }


    static class TransferRequest {
        RequestCommand command


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("TransferRequest{")
            sb.append("command=").append(command)
            sb.append('}')
            return sb.toString()
        }
    }

    static class RequestCommand {
        String type
        String extnwcode
        String msisdn
        String useroriginid
        String password
        String pin
        String extcode
        String exttxnnumber
        String exttxndate
        Product products
        String trfcategory
        String refnumber
        PaymentDetails paymentdetails
        String prefferedlanguage
        String remarks


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("RequestCommand{");
            sb.append("type='").append(type).append('\'');
            sb.append(", extnwcode='").append(extnwcode).append('\'');
            sb.append(", msisdn='").append(msisdn).append('\'');
            sb.append(", useroriginid='").append(useroriginid).append('\'');
            sb.append(", password='").append(password).append('\'');
            sb.append(", pin='").append(pin).append('\'');
            sb.append(", extcode='").append(extcode).append('\'');
            sb.append(", exttxnnumber='").append(exttxnnumber).append('\'');
            sb.append(", exttxndate='").append(exttxndate).append('\'');
            sb.append(", products=").append(products);
            sb.append(", trfcategory='").append(trfcategory).append('\'');
            sb.append(", refnumber='").append(refnumber).append('\'');
            sb.append(", paymentdetails=").append(paymentdetails);
            sb.append(", prefferedlanguage='").append(prefferedlanguage).append('\'');
            sb.append(", remarks='").append(remarks).append('\'');
            sb.append('}');
            return sb.toString();
        }
    }

    static class Product {
        String productcode
        String qty


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("Product{")
            sb.append("productcode='").append(productcode).append('\'')
            sb.append(", qty='").append(qty).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static class PaymentDetails {
        String paymenttype
        String paymentinstnumber
        String paymentdate
        String netpayableamount


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("PaymentDetails{")
            sb.append("paymenttype='").append(paymenttype).append('\'')
            sb.append(", paymentinstnumber='").append(paymentinstnumber).append('\'')
            sb.append(", paymentdate='").append(paymentdate).append('\'')
            sb.append(", netpayableamount='").append(netpayableamount).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static class TransferResponse {
        ResponseCommand COMMAND


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("TransferResponse{")
            sb.append("COMMAND=").append(COMMAND)
            sb.append('}')
            return sb.toString()
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
            final StringBuilder sb = new StringBuilder("ResponseCommand{")
            sb.append("DATE='").append(DATE).append('\'')
            sb.append(", MESSAGE='").append(MESSAGE).append('\'')
            sb.append(", EXTTXNNUMBER='").append(EXTTXNNUMBER).append('\'')
            sb.append(", TYPE='").append(TYPE).append('\'')
            sb.append(", TXNID='").append(TXNID).append('\'')
            sb.append(", TXNSTATUS='").append(TXNSTATUS).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static enum ExtUpdateOrderOperation
    {
        STATUS, ORDER_QUANTITY, STATUS_AND_QUANTITY, TRANSFER_STATUS, SALES_ORDERS
    }
    static class OrderRequest
    {
        String systemToken
        String authorization
    }
    static class ExtUpdateOrderRequest extends OrderRequest
    {
        String orderId
        String resellerId
        String orderStatus
        ExtUpdateOrderOperation operationId
        ExternalActionResult externalActionResult
        boolean searchOrderByInternalId
        SystemToken tokenObj


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ExtUpdateOrderRequest{")
            sb.append("orderId='").append(orderId).append('\'')
            sb.append(", resellerId='").append(resellerId).append('\'')
            sb.append(", orderStatus='").append(orderStatus).append('\'')
            sb.append(", operationId=").append(operationId)
            sb.append(", externalActionResult=").append(externalActionResult)
            sb.append(", tokenObj=").append(tokenObj)
            sb.append('}')
            return sb.toString()
        }
    }

    static class ExternalActionResult
    {
        String externalReference
        Map<String, String> data
        List<SalesOrderItem> salesOrderItems
        TransferResult transferResult


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ExternalActionResult{")
            sb.append("externalReference='").append(externalReference).append('\'')
            sb.append(", data=").append(data)
            sb.append(", salesOrderItems=").append(salesOrderItems)
            sb.append(", transferResult=").append(transferResult)
            sb.append('}')
            return sb.toString()
        }
    }


    static class SalesOrderItem
    {
        String salesOrderNumber
        SalesOrderType salesOrderType
        String status
        Date createdDate


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("SalesOrderItem{")
            sb.append("salesOrderNumber='").append(salesOrderNumber).append('\'')
            sb.append(", salesOrderType=").append(salesOrderType)
            sb.append(", status='").append(status).append('\'')
            sb.append(", createdDate=").append(createdDate)
            sb.append('}')
            return sb.toString()
        }
    }

    static class TransferResult
    {
        String transferType
        String resultCode
        String resultDescription
        Boolean isSuccess


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("TransferResult{")
            sb.append("transferType='").append(transferType).append('\'')
            sb.append(", resultCode='").append(resultCode).append('\'')
            sb.append(", resultDescription='").append(resultDescription).append('\'')
            sb.append(", isSuccess=").append(isSuccess)
            sb.append('}')
            return sb.toString()
        }
    }

    static enum SalesOrderType
    {
        ERS("ERS"), MFS("MFS"), ERP("ERP")

        String value

        SalesOrderType(String value)
        {
            this.value = value
        }

        static SalesOrderType lookup(String val){
            for(SalesOrderType salesOrderType : values())
            {
                if(salesOrderType.value == val)
                {
                    return salesOrderType
                }
            }

            return null
        }

        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("SalesOrderType{")
            sb.append("value='").append(value).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static class BaseResponse {
        String ersReference
        int resultCode
        String resultMessage


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("BaseResponse{")
            sb.append("ersReference='").append(ersReference).append('\'')
            sb.append(", resultCode=").append(resultCode)
            sb.append(", resultMessage='").append(resultMessage).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

}