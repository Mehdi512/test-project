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

class PRIMARY_ORDER_COMPLETE_NOTIFY_TASK extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(PRIMARY_ORDER_COMPLETE_NOTIFY_TASK.class)

    private static final String callbackUrl = "http://svc-order-management:9595/oms/v2/order/confirm-external-flow-completion"

    private SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssXXX")

    private static final String TASK = PRIMARY_ORDER_COMPLETE_NOTIFY_TASK.class.name
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
    }



    @Override
    void createRequest(HelperTransaction transaction) {
        log.info("{} implementation - Creating request for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            String payload = transaction.getInboundRequest().getPayload()
            Payload request = gson.fromJson(payload, Payload.class)
            log.info("Received orderInformation REQUEST: {}", request.orderInformation)
            if(request.orderInformation != null)
            {
                setDefaultSalesOrderVariables(request.orderInformation)
                String orderInfoRequest = gson.toJson(request.orderInformation)
                transaction.getLinkActionInProgress().setRequest(orderInfoRequest)
            }
            else
            {
                log.info("\n ==================\n NO ORDER INFORMATION IN REQUEST TO PROCESS for requestId: [{}] - inboundTxnId: [{}]\n ==================", transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
                throw new SkippableActionException("NO ORDER INFORMATION IN REQUEST TO PROCESS", LinkActionStatus.SKIPPED)
            }


        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", {}, e)
        }
    }

    @Override
    void makeApiCall(HelperTransaction transaction) {

    }

    @Override
    void handleResponse(HelperTransaction transaction) {

    }

    @Override
    void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
    }

    @Override
    void callback(HelperTransaction transaction) {
        log.info("{} implementation - Executing callback for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {

            log.info("Execute callback to notify order that external order flow is completed")
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()
            log.debug("System token: {}", systemToken)
            log.info("Authorization: {}", authorization)

            String strRequest = transaction.getLinkActionInProgress().getRequest()
            OrderInformation orderInformation = gson.fromJson(strRequest, OrderInformation.class)
            String requestOrderId = orderInformation.orderId
            log.info("Request Order Id: [{}]", requestOrderId)


            ConfirmExternalFlowCompletionRequest completionRequest = new ConfirmExternalFlowCompletionRequest()
            completionRequest.orderId = requestOrderId
            completionRequest.confirmationStatus = true

            HttpHeaders headers = getHttpHeaders(systemToken, authorization)
            HttpEntity<ConfirmExternalFlowCompletionRequest> confirmExternalFlowCompletionRequestHttpEntity = new HttpEntity<>(completionRequest, headers)
            ResponseEntity<String> callbackResponse = restTemplate.exchange(callbackUrl, HttpMethod.POST, confirmExternalFlowCompletionRequestHttpEntity, String.class)
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

    static setDefaultSalesOrderVariables(OrderInformation request){
    }


    static class Payload {
        OrderInformation orderInformation
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
    static enum ExtUpdateOrderOperation
    {
        STATUS, ORDER_QUANTITY, STATUS_AND_QUANTITY, TRANSFER_STATUS, SALES_ORDERS, NOTIFY_EXT_FLOW_COMPLETE;


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


    static class ConfirmExternalFlowCompletionRequest extends OrderRequest
    {
        String orderId
        boolean confirmationStatus


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ConfirmExternalFlowCompletionRequest{")
            sb.append("orderId='").append(orderId).append('\'')
            sb.append(", confirmationStatus=").append(confirmationStatus)
            sb.append(", systemToken='").append(systemToken).append('\'')
            sb.append(", authorization='").append(authorization).append('\'')
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
