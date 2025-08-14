import com.fasterxml.jackson.annotation.JsonProperty
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
import se.seamless.idm.entity.LinkActionErrorReason
import se.seamless.idm.enums.LinkActionStatus
import se.seamless.idm.exceptions.ActionProcessingException
import se.seamless.idm.exceptions.SkippableActionException
import se.seamless.idm.model.HelperTransaction
import se.seamless.idm.actions.AbstractAction
import se.seamless.idm.util.CommonUtils

import java.text.SimpleDateFormat

class MONEY_RECEIPTS_CREATION_TASK extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(MONEY_RECEIPTS_CREATION_TASK.class)

    private static final String erpLinkUrl = "http://svc-idm-erp-link:15700/erplink/moneyReceipts"
    private static final String callbackUrl = "http://svc-order-management:9595/oms/v2/ext/order"

    private SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssXXX")

    private static final String TASK = MONEY_RECEIPTS_CREATION_TASK.class.name
    @Override
    void evaluatePreConditions(HelperTransaction transaction) {
        log.info("{} - Checking preconditions for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            transaction.setDynamicData(new HashMap<String, Object>())

        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }

    @Override
    void validateRequest(HelperTransaction transaction) {
        log.info("{} implementation - Validating request for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }



    @Override
    void createRequest(HelperTransaction transaction) {
        log.info("{} implementation - Creating request for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            String payload = transaction.getInboundRequest().getPayload()
            transaction.getLinkActionInProgress().setRequest(payload)
            log.info("Received Money Receipt Request: [{}]", payload)
            MoneyReceiptRequest request = gson.fromJson(payload, MoneyReceiptRequest.class)
            if(request != null)
            {
                setDefaultMoneyReceiptVariables(request)
                String moneyReceiptRequest = gson.toJson(request)
                transaction.getLinkActionInProgress().setRequest(moneyReceiptRequest)
            }
            else
            {
                log.info("\n ==================\n NO MONEY RECEIPT REQUEST IN REQUEST TO PROCESS for requestId: [{}] - inboundTxnId: [{}]\n ==================", transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
                throw new SkippableActionException("NO MONEY RECEIPT REQUEST IN REQUEST TO PROCESS", LinkActionStatus.SKIPPED)
            }


        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", {}, e)
        }
    }

    @Override
    void makeApiCall(HelperTransaction transaction) {
        log.info("{} implementation - Making API call for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {

            transaction.setExternalCallSuccess(false)
            String moneyReceiptRequest = transaction.getLinkActionInProgress().getRequest()
            log.info("Money Receipt Request to ERPLink: [{}]", moneyReceiptRequest)
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()
            HttpHeaders headers = getHttpHeaders(systemToken, authorization)

            HttpEntity<String> requestEntity = new HttpEntity<>(moneyReceiptRequest, headers)

            ResponseEntity<String> responseEntity  = restTemplate.exchange(erpLinkUrl, HttpMethod.POST, requestEntity, String.class)
            log.info("money receipt response from ERPLink: [{}]", responseEntity.getBody())
            transaction.getLinkActionInProgress().setResponse(responseEntity.getBody())
            if(responseEntity.statusCode == HttpStatus.OK){
                String response = transaction.getLinkActionInProgress().getResponse()
                if(response == null || response.isEmpty()){
                    throw new ActionProcessingException("Received empty response")
                }
                CreateMoneyReceiptResponse moneyReceiptResponse =  gson.fromJson(response, CreateMoneyReceiptResponse.class)
                transaction.setExternalCallSuccess(moneyReceiptResponse?.resultCode == 0)
                transaction.setExternalCallResultDescription(moneyReceiptResponse?.resultMessage)
                if(!transaction.isExternalCallSuccess())
                {
                    log.info("external call failed with resultCode: {} and resultMessage: {}", moneyReceiptResponse?.resultCode, moneyReceiptResponse?.resultMessage)
                    throw new ActionProcessingException(String.format("external call failed with resultCode: %d and resultMessage: %s", moneyReceiptResponse?.resultCode, moneyReceiptResponse?.resultMessage))
                }
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
        log.info("{} implementation - Parsing response for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {


        } catch (ActionProcessingException e) {
            log.error("{} implementation - Error parsing response", TASK, e)
            LinkActionErrorReason errorReason = new LinkActionErrorReason()
            errorReason.setLinkAction(transaction.getLinkActionInProgress())
            errorReason.setReason(String.format("DEBUG Point %s implementation", TASK))
            linkActionErrorReasonService.save(errorReason)
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_HANDLE_RESPONSE)
            //Bad code remove this
            throw e
        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }


    @Override
    void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
    }

    @Override
    void callback(HelperTransaction transaction) {
        log.info("{} implementation - Executing callback for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {

            String response = transaction.getLinkActionInProgress().getResponse()
            if(response == null || response.isEmpty()){
                throw new ActionProcessingException("Received empty response")
            }

            CreateMoneyReceiptResponse moneyReceiptResponse =  gson.fromJson(response, CreateMoneyReceiptResponse.class)
            transaction.setExternalCallSuccess(moneyReceiptResponse?.resultCode == 0)
            transaction.setExternalCallResultDescription(moneyReceiptResponse?.resultMessage)
            String receiptNumber = moneyReceiptResponse.receiptNumber
            String standardReceiptId = moneyReceiptResponse.standardReceiptId
            String responseOrderId = moneyReceiptResponse.orderId

            String request = transaction.getLinkActionInProgress().getRequest()
            MoneyReceiptRequest moneyReceiptRequest = gson.fromJson(request, MoneyReceiptRequest.class)

            String requestOrderId = moneyReceiptRequest.orderId

            log.info("Execute callback to update order with Money Receipt details")
            log.info("External call result success status: [{}]", transaction.isExternalCallSuccess())
            log.info("External call result description: [{}]", transaction.getExternalCallResultDescription())
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()
            log.debug("System token: {}", systemToken)
            log.info("Authorization: {}", authorization)

            log.info("Request Order Id: [{}]", requestOrderId)
            log.info("Response Order Id: [{}]", responseOrderId)
            log.info("Receipt Number: [{}]", receiptNumber)
            log.info("Standard Receipt Id: [{}]", standardReceiptId)


            log.info("response after creating money receipt: {}", moneyReceiptResponse)

            ExtUpdateOrderRequest extUpdateOrderRequest = new ExtUpdateOrderRequest()
            extUpdateOrderRequest.orderId = requestOrderId
            extUpdateOrderRequest.tokenObj = transaction.getToken()
            extUpdateOrderRequest.resellerId = moneyReceiptRequest.buyerId
            extUpdateOrderRequest.operationId = ExtUpdateOrderOperation.UPDATE_RECEIPTS
            extUpdateOrderRequest.searchOrderByInternalId = true

            ExternalActionResult externalActionResult = new ExternalActionResult()
            extUpdateOrderRequest.externalActionResult = externalActionResult

            externalActionResult.receiptItems = new ArrayList<>()
            ReceiptItem receiptItem = new ReceiptItem()
            externalActionResult.receiptItems.add(receiptItem)
            receiptItem.primaryId = receiptNumber
            receiptItem.secondaryId = standardReceiptId
            receiptItem.date = new Date()

            HttpHeaders headers = getHttpHeaders(systemToken, authorization)
            HttpEntity<ExtUpdateOrderRequest> extUpdateOrderRequestHttpEntity = new HttpEntity<>(extUpdateOrderRequest, headers)
            ResponseEntity<String> callbackResponse = restTemplate.exchange(callbackUrl, HttpMethod.PUT, extUpdateOrderRequestHttpEntity, String.class)
            if(callbackResponse.statusCode != HttpStatus.OK){
                throw new ActionProcessingException("Callback returned non-200 response code")
            } else {
                log.info("Callback response: {}",  callbackResponse.getBody())
                BaseResponse resp = gson.fromJson(callbackResponse.getBody(), BaseResponse.class)
                if(resp.resultCode != 0){
                    throw new ActionProcessingException("Callback returned non-zero response code")
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


    static HttpHeaders getHttpHeaders(String systemToken, String authorization)
    {
        authorization = StringUtils.isBlank(authorization) ? "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9" : authorization
        log.debug("System-Token : {}", systemToken)
        log.debug("authorization : {}", authorization)

        HttpHeaders headers = new HttpHeaders()
        headers.set("accept", "application/json")
        headers.set("system-token", systemToken)
        headers.set("authorization", authorization)
        headers.set("Content-Type", "application/json")

        return headers
    }

    static setDefaultMoneyReceiptVariables(MoneyReceiptRequest request){
        if(request == null){
            return
        }

        request.setCurrency("BDT")
        request.setBusinessUnit("Grameenphone Ltd.")

        List<RemittanceReference> references = request.getRemittanceReferences()
        if(references != null){
            references.forEach { remittanceReference -> {
                remittanceReference.setReceiptMatchBy("Purchase Order")
            }}
        }
    }


    static class MoneyReceiptRequest
    {
        String orderId
        String buyerId
        String receiptNumber
        String businessUnit
        String receiptMethod
        String receiptDate
        BigDecimal amount
        String currency
        String remittanceBankAccountNumber
        String customerAccountNumber
        String accountingDate
        List<RemittanceReference> remittanceReferences


    }

    static class RemittanceReference {
        String receiptMatchBy
        String referenceNumber
        BigDecimal referenceAmount
    }

    static class CreateMoneyReceiptResponse extends BaseResponse
    {
        String orderId
        String standardReceiptId
        String receiptNumber


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("CreateMoneyReceiptResponse{")
            sb.append("orderId='").append(orderId).append('\'')
            sb.append(", standardReceiptId='").append(standardReceiptId).append('\'')
            sb.append(", receiptNumber='").append(receiptNumber).append('\'')
            sb.append(", ersReference='").append(ersReference).append('\'')
            sb.append(", resultCode=").append(resultCode)
            sb.append(", resultMessage='").append(resultMessage).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static enum ExtUpdateOrderOperation
    {
        STATUS, ORDER_QUANTITY, STATUS_AND_QUANTITY, TRANSFER_STATUS, SALES_ORDERS, UPDATE_RECEIPTS


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ExtUpdateOrderOperation{")
            sb.append('}')
            return sb.toString()
        }
    }
    static class OrderRequest
    {
        String systemToken
        String authorization


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("OrderRequest{")
            sb.append("systemToken='").append(systemToken).append('\'')
            sb.append(", authorization='").append(authorization).append('\'')
            sb.append('}')
            return sb.toString()
        }
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
        List<ReceiptItem> receiptItems
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


    static class ReceiptItem
    {
        String primaryId
        String secondaryId
        Date date
        Map<String, String> data
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
        boolean isSuccess


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
