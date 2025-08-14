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

class ERP_ERS_SO_CREATION_TASK extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(ERP_ERS_SO_CREATION_TASK.class)

    private static final String erpLinkUrl = "http://svc-idm-erp-link:15700/erplink/salesOrders"
    private static final String callbackUrl = "http://svc-order-management:9595/oms/v2/ext/order"

    private SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssXXX")

    private static final String TASK = ERP_ERS_SO_CREATION_TASK.class.name
    @Override
    void evaluatePreConditions(HelperTransaction transaction) {
        log.info("{} - Checking preconditions for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            transaction.setDynamicData(new HashMap<String, Object>())

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
            log.info("Received ERS SO REQUEST: {}", request.SALESORDERS.ERS)
            if(request.SALESORDERS.ERS != null)
            {
                setDefaultSalesOrderVariables(request.SALESORDERS.ERS)
                String salesOrderRequest = gson.toJson(request.SALESORDERS.ERS)
                transaction.getLinkActionInProgress().setRequest(salesOrderRequest)
            }
            else
            {
                log.info("\n ==================\n NO ERS SALES ORDERS IN REQUEST TO PROCESS for requestId: [{}] - inboundTxnId: [{}]\n ==================", transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
                throw new SkippableActionException("NO ERS SALES ORDERS IN REQUEST TO PROCESS", LinkActionStatus.SKIPPED)
            }


        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", {}, e)
        }
    }

    @Override
    void makeApiCall(HelperTransaction transaction) {
        log.info("{} implementation - Making API call for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
        try {

            transaction.setExternalCallSuccess(false)
            String salesOrderRequest = transaction.getLinkActionInProgress().getRequest()
            log.info("ERS SO Request to ERPLink: [{}]", salesOrderRequest)
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()
            HttpHeaders headers = getHttpHeaders(systemToken, authorization)

            HttpEntity<String> requestEntity = new HttpEntity<>(salesOrderRequest, headers)

            ResponseEntity<String> responseEntity  = restTemplate.exchange(erpLinkUrl, HttpMethod.POST, requestEntity, String.class)
            if(responseEntity.statusCode == HttpStatus.OK){
                transaction.getLinkActionInProgress().setResponse(responseEntity.getBody())
                String response = transaction.getLinkActionInProgress().getResponse()
                if(response == null || response.isEmpty()){
                    throw new ActionProcessingException("Received empty response")
                }

                log.info("Response received from ERP: [{}]", responseEntity.getBody())
                CreateSalesOrderResponse salesOrderResponse =  gson.fromJson(responseEntity.getBody(), CreateSalesOrderResponse.class)
                if(salesOrderResponse == null)
                {
                    transaction.setExternalCallSuccess(false)
                    throw new ActionProcessingException("Null response received from remote endpoint")
                }
                transaction.setExternalCallSuccess(salesOrderResponse.resultCode == 0)
                if(!transaction.isExternalCallSuccess())
                {
                    log.error("transaction failed with result code: [{}] and description: [{}]", salesOrderResponse.resultCode, salesOrderResponse.resultDescription)
                    throw new ActionProcessingException(String.format("transaction failed with result code: [%d] and description: [%s]", salesOrderResponse?.resultCode, salesOrderResponse?.resultDescription))
                }

                String SO_NUMBER = salesOrderResponse.soNumber
                if(com.seamless.common.StringUtils.isBlank(SO_NUMBER)){
                    CreateSalesOrderRequest createSalesOrderRequest = null
                    try
                    {
                        //try to retrieve orderId
                        createSalesOrderRequest = gson.fromJson(salesOrderRequest, CreateSalesOrderRequest.class)
                    }
                    catch(Exception ignore){

                    }
                    throw new ActionProcessingException(String.format("Generated SO Number is blank: [%s], orderId: [%s]", SO_NUMBER, createSalesOrderRequest?.orderId))
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
        log.info("{} implementation - Parsing response for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
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
        log.info("{} implementation - Executing callback for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getInboundTxnId(), transaction.getInboundRequest().getInboundTxnId())
        try {

            String response = transaction.getLinkActionInProgress().getResponse()
            if(response == null || response.isEmpty()){
                throw new ActionProcessingException("Received empty response")
            }
            CreateSalesOrderResponse salesOrderResponse = gson.fromJson(response, CreateSalesOrderResponse.class)


            String SO_NUMBER = salesOrderResponse.soNumber
            String RESPONSE_ORDER_ID=  salesOrderResponse.orderId
            String ORDER_KEY =  salesOrderResponse.orderKey
            String SO_CREATION_DATE = salesOrderResponse.creationDate
            String SO_STATUS = salesOrderResponse.statusCode

            log.info("Execute callback to update order with SO details")
            log.info("External call result success status: [{}]", salesOrderResponse.resultCode == 0)
            log.info("External call result: [{}]", salesOrderResponse.messageText)
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()
            log.debug("System token: {}", systemToken)
            log.info("Authorization: {}", authorization)

            log.info("Generated SO Number: [{}]", SO_NUMBER)
            log.info("Response Order Id: [{}]", RESPONSE_ORDER_ID)
            log.info("Response Order Key: [{}]", ORDER_KEY)
            log.info("SO Creation Date: [{}]", SO_CREATION_DATE)
            log.info("SO Status: [{}]", SO_STATUS)

            String request = transaction.getLinkActionInProgress().getRequest()
            if(request == null || request.isEmpty()){
                throw new ActionProcessingException("Received empty response")
            }

            CreateSalesOrderRequest ERS =  gson.fromJson(request, CreateSalesOrderRequest.class)

            ExtUpdateOrderRequest extUpdateOrderRequest = new ExtUpdateOrderRequest()
            extUpdateOrderRequest.orderId = ERS.orderId
            extUpdateOrderRequest.tokenObj = transaction.getToken()
            extUpdateOrderRequest.resellerId = ERS.buyingPartyId
            extUpdateOrderRequest.operationId = ExtUpdateOrderOperation.SALES_ORDERS
            extUpdateOrderRequest.searchOrderByInternalId = true

            ExternalActionResult externalActionResult = new ExternalActionResult()
            extUpdateOrderRequest.externalActionResult = externalActionResult

            externalActionResult.salesOrderItems = new ArrayList<>()
            SalesOrderItem salesOrderItem = new SalesOrderItem()
            externalActionResult.salesOrderItems.add(salesOrderItem)
            salesOrderItem.salesOrderNumber = SO_NUMBER
            salesOrderItem.salesOrderType = SalesOrderType.ERS
            salesOrderItem.status = SO_STATUS
            if(com.seamless.common.StringUtils.isNotBlank(SO_CREATION_DATE)){
                salesOrderItem.createdDate = simpleDateFormat.parse(SO_CREATION_DATE)
            } else {
                salesOrderItem.createdDate = new Date()
            }

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

    static setDefaultSalesOrderVariables(CreateSalesOrderRequest request){
        if(request == null){
            return
        }

        request.sourceTransactionSystem = "DMS"
        request.businessUnitName = "Grameenphone Ltd."
        request.paymentTerms = "Immediate"
        request.transactionTypeCode = "GP FlexiLoad Order"
        request.requestedFulfillmentOrganizationName = "Grameenphone - Saleable Inventory Org"
        request.requestingBusinessUnitName = "Grameenphone Ltd."
        request.freezePriceFlag = false
        request.freezeShippingChargeFlag = false
        request.freezeTaxFlag = false
        request.submittedFlag = true

        List<Line> lines = request.lines
        if(lines == null) {
            return
        }

        lines.forEach { line -> {
            line.transactionLineType = "BUY"
            line.transactionCategoryCode = "ORDER"
            line.orderedUOM = "Each"

            List<AdditionalInformation> additionalInformation = line.additionalInformation
            if(additionalInformation != null){
                additionalInformation.forEach { addInfo -> {
                    addInfo.category = "DOO_FULFILL_LINES_ADD_INFO"
                    List<FulfillLineEffBCommissionInfoprivateVO> fulfillLineEffBCommissionInfoprivateVO = addInfo.fulfillLineEffBCommissionInfoprivateVO
                    if(fulfillLineEffBCommissionInfoprivateVO != null){
                         fulfillLineEffBCommissionInfoprivateVO.forEach { it -> {
                             it.contextCode = "CommissionInfo"
                         }}
                    }
                }}
            }

            List<ManualPriceAdjustment> manualPriceAdjustments = line.manualPriceAdjustments
            if(manualPriceAdjustments != null){
                manualPriceAdjustments.forEach { manualPriceAdjustment -> {
                    manualPriceAdjustment.reason = "Price match"
                    manualPriceAdjustment.adjustmentType = "Discount amount"
                    manualPriceAdjustment.chargeDefinition = "Sale Price"
                    manualPriceAdjustment.adjustmentElementBasisName = "Your Price"
                    manualPriceAdjustment.chargeRollupFlag = false
                    manualPriceAdjustment.comments = "Discount requested"
                    manualPriceAdjustment.sourceManualPriceAdjustmentId = "PS101"
                    manualPriceAdjustment.sequenceNumber = 1
                }}
            }
            else {
                line.manualPriceAdjustments = new ArrayList<>()
            }
        }}


    }


    static class Payload {
        SalesOrders SALESORDERS
    }

    static class SalesOrders {
        CreateSalesOrderRequest ERS
    }

    static class CreateSalesOrderRequest
    {
        String orderId
        String sourceTransactionSystem
        String sourceTransactionId
        String sourceTransactionNumber
        String businessUnitName
        String buyingPartyId
        String buyingPartyName
        String transactionTypeCode
        String customerPONumber
        String transactionOn
        String requestedShipDate
        String paymentTerms
        String transactionalCurrencyCode
        String requestedFulfillmentOrganizationName
        String requestingBusinessUnitName
        boolean freezePriceFlag
        boolean freezeShippingChargeFlag
        boolean freezeTaxFlag
        boolean submittedFlag
        List<BillToCustomer> billToCustomer
        List<ShipToCustomer> shipToCustomer
        List<Line> lines


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("CreateSalesOrderRequest{")
            sb.append("orderId='").append(orderId).append('\'')
            sb.append(", sourceTransactionSystem='").append(sourceTransactionSystem).append('\'')
            sb.append(", sourceTransactionId='").append(sourceTransactionId).append('\'')
            sb.append(", sourceTransactionNumber='").append(sourceTransactionNumber).append('\'')
            sb.append(", businessUnitName='").append(businessUnitName).append('\'')
            sb.append(", buyingPartyName='").append(buyingPartyName).append('\'')
            sb.append(", transactionTypeCode='").append(transactionTypeCode).append('\'')
            sb.append(", customerPONumber='").append(customerPONumber).append('\'')
            sb.append(", transactionOn='").append(transactionOn).append('\'')
            sb.append(", requestedShipDate='").append(requestedShipDate).append('\'')
            sb.append(", paymentTerms='").append(paymentTerms).append('\'')
            sb.append(", transactionalCurrencyCode='").append(transactionalCurrencyCode).append('\'')
            sb.append(", requestedFulfillmentOrganizationName='").append(requestedFulfillmentOrganizationName).append('\'')
            sb.append(", requestingBusinessUnitName='").append(requestingBusinessUnitName).append('\'')
            sb.append(", freezePriceFlag=").append(freezePriceFlag)
            sb.append(", freezeShippingChargeFlag=").append(freezeShippingChargeFlag)
            sb.append(", freezeTaxFlag=").append(freezeTaxFlag)
            sb.append(", submittedFlag=").append(submittedFlag)
            sb.append(", billToCustomer=").append(billToCustomer)
            sb.append(", shipToCustomer=").append(shipToCustomer)
            sb.append(", lines=").append(lines)
            sb.append('}')
            return sb.toString()
        }
    }

    static class CreateSalesOrderResponse
    {
        int resultCode
        String resultMessage
        String resultDescription
        String orderId
        String soNumber
        String statusCode
        String creationDate
        String orderKey
        String messageText


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("CreateSalesOrderResponse{")
            sb.append("resultCode=").append(resultCode)
            sb.append(", resultMessage='").append(resultMessage).append('\'')
            sb.append(", resultDescription='").append(resultDescription).append('\'')
            sb.append(", orderId='").append(orderId).append('\'')
            sb.append(", soNumber='").append(soNumber).append('\'')
            sb.append(", statusCode='").append(statusCode).append('\'')
            sb.append(", creationDate='").append(creationDate).append('\'')
            sb.append(", orderKey='").append(orderKey).append('\'')
            sb.append(", messageText='").append(messageText).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static class AdditionalInformation
    {
        String category
        List<FulfillLineEffBCommissionInfoprivateVO> fulfillLineEffBCommissionInfoprivateVO


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("AdditionalInformation{")
            sb.append("category='").append(category).append('\'')
            sb.append(", fulfillLineEffBCommissionInfoprivateVO=").append(fulfillLineEffBCommissionInfoprivateVO)
            sb.append('}')
            return sb.toString()
        }
    }

    static class BillToCustomer
    {
        String partyName
        String accountNumber
        String siteUseId


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("BillToCustomer{")
            sb.append("partyName='").append(partyName).append('\'')
            sb.append(", accountNumber='").append(accountNumber).append('\'')
            sb.append(", siteUseId='").append(siteUseId).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static class FulfillLineEffBCommissionInfoprivateVO
    {
        String contextCode
        String distributorcommission
        String retailercommission


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("FulfillLineEffBCommissionInfoprivateVO{")
            sb.append("contextCode='").append(contextCode).append('\'')
            sb.append(", distributorcommission='").append(distributorcommission).append('\'')
            sb.append(", retailercommission='").append(retailercommission).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }

    static class Line
    {
        String sourceTransactionLineId
        String sourceTransactionLineNumber
        String sourceTransactionScheduleId
        String sourceScheduleNumber
        String scheduleShipDate
        String transactionLineType
        String transactionCategoryCode
        String productNumber
        String orderedQuantity
        String orderedUOM
        List<ManualPriceAdjustment> manualPriceAdjustments
        List<AdditionalInformation> additionalInformation


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("Line{")
            sb.append("sourceTransactionLineId='").append(sourceTransactionLineId).append('\'')
            sb.append(", sourceTransactionLineNumber='").append(sourceTransactionLineNumber).append('\'')
            sb.append(", sourceTransactionScheduleId='").append(sourceTransactionScheduleId).append('\'')
            sb.append(", sourceScheduleNumber='").append(sourceScheduleNumber).append('\'')
            sb.append(", scheduleShipDate='").append(scheduleShipDate).append('\'')
            sb.append(", transactionLineType='").append(transactionLineType).append('\'')
            sb.append(", transactionCategoryCode='").append(transactionCategoryCode).append('\'')
            sb.append(", productNumber='").append(productNumber).append('\'')
            sb.append(", orderedQuantity='").append(orderedQuantity).append('\'')
            sb.append(", orderedUOM='").append(orderedUOM).append('\'')
            sb.append(", manualPriceAdjustments=").append(manualPriceAdjustments)
            sb.append(", additionalInformation=").append(additionalInformation)
            sb.append('}')
            return sb.toString()
        }
    }

    static class ManualPriceAdjustment
    {
        String reason
        double adjustmentAmount
        String adjustmentType
        String chargeDefinition
        String adjustmentElementBasisName
        boolean chargeRollupFlag
        String comments
        String sourceManualPriceAdjustmentId
        int sequenceNumber


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ManualPriceAdjustment{")
            sb.append("reason='").append(reason).append('\'')
            sb.append(", adjustmentAmount=").append(adjustmentAmount)
            sb.append(", adjustmentType='").append(adjustmentType).append('\'')
            sb.append(", chargeDefinition='").append(chargeDefinition).append('\'')
            sb.append(", adjustmentElementBasisName='").append(adjustmentElementBasisName).append('\'')
            sb.append(", chargeRollupFlag=").append(chargeRollupFlag)
            sb.append(", comments='").append(comments).append('\'')
            sb.append(", sourceManualPriceAdjustmentId='").append(sourceManualPriceAdjustmentId).append('\'')
            sb.append(", sequenceNumber=").append(sequenceNumber)
            sb.append('}')
            return sb.toString()
        }
    }

    static class ShipToCustomer
    {
        String partyName
        String partyId
        String siteId


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ShipToCustomer{")
            sb.append("partyName='").append(partyName).append('\'')
            sb.append(", partyId='").append(partyId).append('\'')
            sb.append(", siteId='").append(siteId).append('\'')
            sb.append('}')
            return sb.toString()
        }
    }


    static enum ExtUpdateOrderOperation
    {
        STATUS, ORDER_QUANTITY, STATUS_AND_QUANTITY, TRANSFER_STATUS, SALES_ORDERS


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
