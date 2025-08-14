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
import se.seamless.idm.model.HelperTransaction
import se.seamless.idm.actions.AbstractAction
import se.seamless.idm.util.CommonUtils

class ERP_CREATE_MOVE_ORDER extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(ERP_CREATE_MOVE_ORDER.class)
    private static final String RESPONSE_BODY = "RESPONSE_BODY"
    private static final String EXTERNAL_CALL_RESULT_CODE = "EXTERNAL_CALL_RESULT_CODE"

    private static final String erpMoveOrderUrl = "http://svc-idm-erp-link:15700/erplink/moveOrders"
    private static final String callbackUrl = "http://svc-order-management:9595/oms/v2/ext/order"

    private static final String TASK = ERP_CREATE_MOVE_ORDER.class.name

    @Override
    void evaluatePreConditions(HelperTransaction transaction) {
        log.info("{} - Checking preconditions for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            // Add any precondition checks here
        } catch (InterruptedException e) {
            log.error("{} - Thread interrupted", TASK, e)
        }
    }

    @Override
    void validateRequest(HelperTransaction transaction) {
        log.info("{} - Validating request for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            String payload = transaction.getInboundRequest().getPayload()
            log.info("{} - ERP MOVE ORDER PAYLOAD: {}", TASK, payload)
        } catch (InterruptedException e) {
            log.error("{} - Thread interrupted", TASK, e)
        }
    }

    @Override
    void createRequest(HelperTransaction transaction) {
        log.info("{} - Creating request for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            String payload = transaction.getInboundRequest().getPayload()
            transaction.getLinkActionInProgress().setRequest(payload)
        } catch (InterruptedException e) {
            log.error("{} - Thread interrupted", TASK, e)
        }
    }

    @Override
    void makeApiCall(HelperTransaction transaction) {
        log.info("{} - Making API call for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        transaction.setExternalCallSuccess(false)
        try {
            String request = (String) transaction.getLinkActionInProgress().getRequest()
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()

            log.info("{} - Preparing API call with request: {}", TASK, request)
            log.debug("{} - System token: {}, Authorization: {}", TASK, systemToken, authorization)

            HttpHeaders headers = getHttpHeaders(systemToken, authorization)
            HttpEntity<String> requestEntity = new HttpEntity<>(request, headers)

            log.info("{} - Making POST request to URL: {}", TASK, erpMoveOrderUrl)
            ResponseEntity<String> responseEntity = restTemplate.exchange(erpMoveOrderUrl, HttpMethod.POST, requestEntity, String.class)

            log.info("{} - Received response with status code: {}", TASK, responseEntity.statusCode)
            log.info("{} - Response body: {}", TASK, responseEntity.getBody())
            transaction.getLinkActionInProgress().setResponse(responseEntity.getBody())

            if (responseEntity.statusCode == HttpStatus.OK) {
                log.info("{} - Response status code is OK (200), processing response", TASK)
                MoveOrderResponse responseObj = gson.fromJson(responseEntity.getBody(), MoveOrderResponse.class)
                log.debug("{} - Unmarshalled response object: {}", TASK, responseObj.toString())

                if (responseObj == null) {
                    log.error("{} - Null response object received from remote endpoint", TASK)
                    transaction.setExternalCallSuccess(false)
                    throw new ActionProcessingException("Null response received from remote endpoint")
                }

                boolean isSuccess = responseObj.resultCode == 0
                log.info("{} - Setting external call success to: {}", TASK, isSuccess)
                transaction.setExternalCallSuccess(isSuccess)

                if (!transaction.isExternalCallSuccess()) {
                    log.error("{} - Transaction failed with result code: [{}] and description: [{}]", TASK, responseObj?.resultCode, responseObj?.resultMessage)
                    throw new ActionProcessingException(String.format("Transaction failed with result code: [%d] and description: [%s]", responseObj?.resultCode, responseObj?.resultMessage))
                } else {
                    log.info("{} - Transaction successful with result code: [{}] and message: [{}]", TASK, responseObj?.resultCode, responseObj?.resultMessage)
                }
            } else {
                log.error("{} - API Call returned non-200 response code: {}", TASK, responseEntity.statusCode)
                transaction.setExternalCallResultDescription("API Call returned non-200 response code")
                throw new ActionProcessingException("API Call returned non-200 response code")
            }
        } catch (Exception e) {
            log.error("{} - Exception occurred during API call", TASK, e)
            LinkActionErrorReason errorReason = new LinkActionErrorReason()
            errorReason.setLinkAction(transaction.getLinkActionInProgress())
            if (e instanceof HttpClientErrorException) {
                log.warn("{} - HTTP Client Exception - Check request", TASK)
                errorReason.setReason("HTTP Client Exception - Check request")
            } else if (e instanceof HttpServerErrorException) {
                log.error("{} - HttpServerErrorException exception", TASK, e)
                errorReason.setReason("HttpServerErrorException exception")
            } else if (e instanceof ActionProcessingException) {
                log.error("{} - ActionProcessingException: {}", TASK, e.getMessage(), e)
                errorReason.setReason(e.getMessage())
            } else {
                log.error("{} - Unexpected exception: {}", TASK, e.getMessage(), e)
                errorReason.setReason("Unexpected exception: " + e.getMessage())
            }
            linkActionErrorReasonService.save(errorReason)
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL)
            throw e
        }
    }

    @Override
    void handleResponse(HelperTransaction transaction) {
        log.info("{} - Parsing response for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            // Add any response handling logic here
        } catch (ActionProcessingException e) {
            log.error("{} - Error parsing response", TASK, e)
            LinkActionErrorReason errorReason = new LinkActionErrorReason()
            errorReason.setLinkAction(transaction.getLinkActionInProgress())
            errorReason.setReason(String.format("DEBUG Point %s implementation", TASK))
            linkActionErrorReasonService.save(errorReason)
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_HANDLE_RESPONSE)
            throw e
        } catch (InterruptedException e) {
            log.error("{} - Thread interrupted", TASK, e)
        }
    }

    @Override
    void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
        // Add any response data extraction logic here
    }

    @Override
    void callback(HelperTransaction transaction) {
        log.info("{} - Executing callback for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            final String requestPayload = transaction.getLinkActionInProgress().getRequest()
            final String systemToken = transaction.getInboundRequest().getToken()
            final String authorization = transaction.getInboundRequest().getAuthorization()
            final String requestId = transaction.getInboundRequest().getId()
            final String inboundTxnId = transaction.getInboundRequest().getInboundTxnId()

            final MoveOrderRequest moveOrderRequest = gson.fromJson(requestPayload, MoveOrderRequest.class)
            final String responsePayload = transaction.getLinkActionInProgress().getResponse()
            final MoveOrderResponse moveOrderResponse = gson.fromJson(responsePayload, MoveOrderResponse.class)

            log.info("{} - Request Number: [{}] for requestId: {} with inboundTxnId: {}", TASK, moveOrderRequest.requestNumber, requestId, inboundTxnId)
            log.info("{} - External Call ResultCode: [{}] for requestId: {} with inboundTxnId: {}", TASK, moveOrderResponse.resultCode, requestId, inboundTxnId)
            log.info("{} - External Call Success Status: [{}] for requestId: {} with inboundTxnId: {}", TASK, transaction.isExternalCallSuccess(), requestId, inboundTxnId)
            log.info("{} - External Call Response Message: [{}] for requestId: {} with inboundTxnId: {}", TASK, transaction.getExternalCallResultDescription(), requestId, inboundTxnId)


            log.info("{} - Preparing callback request for request number: {}", TASK, moveOrderRequest.requestNumber)



            ExtUpdateOrderRequest extUpdateOrderRequest = new ExtUpdateOrderRequest()
            extUpdateOrderRequest.orderId = moveOrderRequest.requestNumber
            extUpdateOrderRequest.tokenObj = transaction.getToken()
            extUpdateOrderRequest.resellerId = moveOrderRequest.orderInformation.buyer.id
            extUpdateOrderRequest.operationId = ExtUpdateOrderOperation.MOVE_ORDER_SALES_ORDER_UPDATE
            extUpdateOrderRequest.searchOrderByInternalId = true

            ExternalActionResult externalActionResult = new ExternalActionResult()
            extUpdateOrderRequest.externalActionResult = externalActionResult

            externalActionResult.salesOrderItems = new ArrayList<>()
            SalesOrderItem salesOrderItem = new SalesOrderItem()
            externalActionResult.salesOrderItems.add(salesOrderItem)
            salesOrderItem.salesOrderNumber = moveOrderResponse.requestNumber
            salesOrderItem.salesOrderType = SalesOrderType.ERP
            salesOrderItem.status = "OPEN"
            salesOrderItem.createdDate = new Date()

            final HttpHeaders headers = getHttpHeaders(systemToken, authorization)
            final HttpEntity<ExtUpdateOrderRequest> callbackRequestEntity = new HttpEntity<>(extUpdateOrderRequest, headers)

            log.info("{} - Making callback request to URL: {}", TASK, callbackUrl)
            final ResponseEntity<String> callbackResponseEntity = restTemplate.exchange(
                    callbackUrl,
                    HttpMethod.PUT,
                    callbackRequestEntity,
                    String.class
            )

            if(callbackResponseEntity.statusCode != HttpStatus.OK){
                throw new ActionProcessingException("Callback returned non-200 response code")
            } else {
                log.info("Callback response: {}",  callbackResponseEntity.getBody())
                BaseResponse resp = gson.fromJson(callbackResponseEntity.getBody(), BaseResponse.class)
                if(resp.resultCode != 0){
                    throw new ActionProcessingException("Callback returned non-zero response code")
                }
            }

            log.info("{} - Callback executed successfully for request number: {}", TASK, moveOrderRequest.requestNumber)
        } catch (Exception e) {
            log.error("{} - Error executing callback: {}", TASK, e.getMessage())
            throw new ActionProcessingException("Error executing callback: " + e.getMessage())
        }
    }

    HttpHeaders getHttpHeaders(String systemToken, String authorization) {
        authorization = StringUtils.isBlank(authorization) ? "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9" : authorization
        log.debug("{} - System-Token: {}", TASK, systemToken)
        log.debug("{} - Authorization: {}", TASK, authorization)

        HttpHeaders headers = new HttpHeaders()
        headers.set("accept", "application/json")
        headers.set("system-token", systemToken)
        headers.set("authorization", authorization)
        headers.set("Content-Type", "application/json")

        return headers
    }

    static class MoveOrderRequest {
        String requestNumber
        Long organizationId
        String requiredDate
        String status
        Integer statusCode
        String transactionType
        String sourceSubinventory
        String destinationSubinventory
        String transactionTypeId
        List<MoveOrderLine> lines
        OrderInformation orderInformation

        @Override
        String toString() {
            return "MoveOrderRequest{" +
                    "requestNumber='" + requestNumber + '\'' +
                    ", organizationId=" + organizationId +
                    ", requiredDate='" + requiredDate + '\'' +
                    ", status='" + status + '\'' +
                    ", statusCode=" + statusCode +
                    ", transactionType='" + transactionType + '\'' +
                    ", sourceSubinventory='" + sourceSubinventory + '\'' +
                    ", destinationSubinventory='" + destinationSubinventory + '\'' +
                    ", transactionTypeId='" + transactionTypeId + '\'' +
                    ", lines=" + lines +
                    '}'
        }
    }

    static class MoveOrderLine {
        String uomCode
        String itemNumber
        Integer requestedQuantity
        String reference

        @Override
        String toString() {
            return "MoveOrderLine{" +
                    "uomCode='" + uomCode + '\'' +
                    ", itemNumber='" + itemNumber + '\'' +
                    ", requestedQuantity=" + requestedQuantity +
                    ", reference='" + reference + '\'' +
                    '}'
        }
    }

    static class MoveOrderResponse {
        int resultCode
        String resultMessage
        String requestNumber


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("MoveOrderResponse{")
            sb.append("resultCode=").append(resultCode)
            sb.append(", resultMessage='").append(resultMessage).append('\'')
            sb.append(", requestNumber='").append(requestNumber).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static class MoveOrderData {
        String moveOrderId
        String status

        @Override
        String toString() {
            return "MoveOrderData{" +
                    "moveOrderId='" + moveOrderId + '\'' +
                    ", status='" + status + '\'' +
                    '}'
        }
    }



    //------------------------------------------//
    static enum ExtUpdateOrderOperation
    {
        STATUS, ORDER_QUANTITY, STATUS_AND_QUANTITY, TRANSFER_STATUS, SALES_ORDERS,MOVE_ORDER_SALES_ORDER_UPDATE


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

    static class OrderInformation
    {
        String orderId
        String orderType
        PartyView buyer
        PartyView seller
        PartyView sender
        PartyView receiver
        PartyView initiator
        String paymentMode
        String paymentAgreement


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("OrderInformation{")
            sb.append("orderId='").append(orderId).append('\'')
            sb.append(", orderType='").append(orderType).append('\'')
            sb.append(", buyer=").append(buyer)
            sb.append(", seller=").append(seller)
            sb.append(", sender=").append(sender)
            sb.append(", receiver=").append(receiver)
            sb.append(", initiator=").append(initiator)
            sb.append(", paymentMode='").append(paymentMode).append('\'')
            sb.append(", paymentAgreement='").append(paymentAgreement).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static class PartyView
    {
        String id
        String idType
        ResellerLifecycleAttributes partyLifeCycleAttributes
        String name
        String email
        String msisdn
        String addressId
        String hierarchyPath
        String typeId
        ERSPrincipalId ersPrincipalId
        String employeeId


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("PartyView{")
            sb.append("id='").append(id).append('\'')
            sb.append(", idType='").append(idType).append('\'')
            sb.append(", partyLifeCycleAttributes=").append(partyLifeCycleAttributes)
            sb.append(", name='").append(name).append('\'')
            sb.append(", email='").append(email).append('\'')
            sb.append(", msisdn='").append(msisdn).append('\'')
            sb.append(", addressId='").append(addressId).append('\'')
            sb.append(", hierarchyPath='").append(hierarchyPath).append('\'')
            sb.append(", typeId='").append(typeId).append('\'')
            sb.append(", ersPrincipalId=").append(ersPrincipalId)
            sb.append(", employeeId='").append(employeeId).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static class ResellerLifecycleAttributes {
        String balanceStatus
        String inventoryStatus
        String balanceLifeline
        String inventoryLifeline
        String lastBalanceInactiveDate
        String lastScratchcardInactiveDate


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ResellerLifecycleAttributes{")
            sb.append("balanceStatus='").append(balanceStatus).append('\'')
            sb.append(", inventoryStatus='").append(inventoryStatus).append('\'')
            sb.append(", balanceLifeline='").append(balanceLifeline).append('\'')
            sb.append(", inventoryLifeline='").append(inventoryLifeline).append('\'')
            sb.append(", lastBalanceInactiveDate='").append(lastBalanceInactiveDate).append('\'')
            sb.append(", lastScratchcardInactiveDate='").append(lastScratchcardInactiveDate).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static class ERSPrincipalId {
        String type
        String id


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ERSPrincipalId{")
            sb.append("type='").append(type).append('\'')
            sb.append(", id='").append(id).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }
}
