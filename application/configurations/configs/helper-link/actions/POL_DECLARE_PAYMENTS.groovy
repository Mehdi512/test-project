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

class POL_DECLARE_PAYMENTS extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(POL_DECLARE_PAYMENTS.class)

    private static final String paymentUrl = "http://svc-idm-pol-link:15900/pollink/api/payments"
    private static final String callbackUrl = "http://svc-order-management:9595/oms/v2/order/confirm-payment-submission"

    private static final String TASK = POL_DECLARE_PAYMENTS.class.name

    @Override
    void evaluatePreConditions(HelperTransaction transaction) {
        log.info("{} - Checking preconditions for requestId: {} with inboundTxnId: {}",TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {

        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }

    @Override
    void validateRequest(HelperTransaction transaction) {
        log.info("{} implementation - Validating request for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            String payload = transaction.getInboundRequest().getPayload()
            log.info("POL PAYLOAD: {}", payload)
        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }

    @Override
    void createRequest(HelperTransaction transaction) {
        log.info("{} implementation - Creating request for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            transaction.getLinkActionInProgress().setRequest(transaction.getInboundRequest().getPayload())
        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }

    @Override
    void makeApiCall(HelperTransaction transaction) {
        log.info("{} implementation - Making API call for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        transaction.setExternalCallSuccess(false)
        try {
            String request = (String) transaction.getLinkActionInProgress().getRequest()
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()
            HttpHeaders headers = getHttpHeaders(systemToken, authorization)
            HttpEntity<String> requestEntity = new HttpEntity<>(request, headers)
            ResponseEntity<String> responseEntity = restTemplate.exchange(paymentUrl, HttpMethod.POST, requestEntity, String.class)
            log.info("response from POLLink: [{}]", responseEntity.getBody())
            transaction.getLinkActionInProgress().setResponse(responseEntity.getBody())
            if (responseEntity.statusCode == HttpStatus.CREATED || responseEntity.statusCode == HttpStatus.OK) {
                String response = (String) transaction.getLinkActionInProgress().getResponse()
                ResponseObj responseObj = gson.fromJson(response, ResponseObj.class)
                log.debug("unmarshalled response: {}",responseObj.toString())
                if(responseObj == null)
                {
                    transaction.setExternalCallSuccess(false)
                    throw new ActionProcessingException("Null response received from remote endpoint")
                }
                String responseStatus= responseObj?.status
                transaction.setExternalCallSuccess(responseStatus =="true")
                transaction.setExternalCallResultDescription(responseObj?.message)

                if(!transaction.isExternalCallSuccess())
                {
                    log.error("transaction failed with result status: [{}] and description: [{}]", responseObj?.status, responseObj?.message)
                    throw new ActionProcessingException(String.format("transaction failed with result code: [%d] and description: [%s]", responseObj?.status, responseObj?.message))
                }
            } else {
                log.error("result code returned: {}", responseEntity.statusCode)
                transaction.setExternalCallResultDescription("API Call returned " + responseEntity.statusCode + " response code which is not considered successful")
                throw new ActionProcessingException("API Call returned " + responseEntity.statusCode + " response code which is not considered successful")
            }

        } catch (Exception e) {
            LinkActionErrorReason errorReason = new LinkActionErrorReason()
            errorReason.setLinkAction(transaction.getLinkActionInProgress())
            if (e instanceof HttpClientErrorException) {
                log.warn("HTTP Client Exception -  Check request")
                errorReason.setReason("HTTP Client Exception -  Check request")
            } else if (e instanceof HttpServerErrorException) {
                log.error("HttpServerErrorException exception", e)
                errorReason.setReason("HttpServerErrorException exception")
            } else if (e instanceof ActionProcessingException) {
                log.error(e.getMessage(), e)
                errorReason.setReason(e.getMessage())
            } else {
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
            errorReason.setReason("DEBUG Point POL_DECLARE_PAYMENTS implementation")
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
            PaymentDeclarationRequest request = gson.fromJson(transaction.getLinkActionInProgress().getRequest(), PaymentDeclarationRequest.class)
            String requestId = transaction.getInboundRequest().getId()
            String inboundTxId = transaction.getInboundRequest().getInboundTxnId()
            log.info("Request Type: [{}] for requestId: {} with inboundTxnId: {}", transaction.getInboundRequest().operationType, requestId, inboundTxId)
            log.info("Order ID: [{}] for requestId: {} with inboundTxnId: {}", request.purchaseDetails.id, requestId, inboundTxId)
            log.info("External Call Success Status:  [{}] for requestId: {} with inboundTxnId: {}", transaction.isExternalCallSuccess(), requestId, inboundTxId)
            log.info("External Call Response Message: [{}] for requestId: {} with inboundTxnId: {}", transaction.getExternalCallResultDescription(), requestId, inboundTxId)

            String response = transaction.getLinkActionInProgress().getResponse()
            ResponseObj responseObj =  gson.fromJson(response, ResponseObj.class)
            transaction.setExternalCallSuccess(responseObj?.status == "true")
            if (transaction.isExternalCallSuccess()) {
                CallbackRequest callbackRequest = new CallbackRequest()
                callbackRequest.setOrderId(request.id)
                callbackRequest.setResultCode(0)
                callbackRequest.setResultMessage("SUCCESS")
                log.info(callbackRequest.toString())
                HttpHeaders headers = getHttpHeaders("", "")
                HttpEntity<CallbackRequest> callbackRequestHttpEntity = new HttpEntity<>(callbackRequest, headers)
                ResponseEntity<String> callbackResponse = restTemplate.exchange(callbackUrl, HttpMethod.POST, callbackRequestHttpEntity, String.class)
                if (callbackResponse.statusCode != HttpStatus.OK) {
                    throw new ActionProcessingException("Callback returned non-200 response code")
                } else {
                    log.info("Callback response: {}", callbackResponse.getBody())
                    CallbackResponse resp = gson.fromJson(callbackResponse.getBody(), CallbackResponse.class)
                    if (resp.resultCode != 0) {
                        throw new ActionProcessingException("Callback returned non-zero response code")
                    }
                }
            }
            else
            {
                //this branch should not get invoked as this condition is handled already in makeApiCall. It's here so something gets logged
                //if some refactoring accidentally breaks something
                log.error("transaction failed with result code: [{}] and description: [{}]", responseObj?.status, responseObj?.message)
                throw new ActionProcessingException(String.format("transaction failed with result code: [%d] and description: [%s]", responseObj?.status, responseObj?.message))
            }
        }
        catch (Exception e) {
            log.error("{} implementation - Thread interrupted", TASK,e)
            LinkActionErrorReason errorReason = new LinkActionErrorReason()
            errorReason.setLinkAction(transaction.getLinkActionInProgress())
            errorReason.setReason(e.getMessage())
            linkActionErrorReasonService.save(errorReason)
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_CALLBACK)
            throw e
        }
    }


    HttpHeaders getHttpHeaders(String systemToken, String authorization) {
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

    static class ResponseObj {
        String id
        String href
        String status
        String message
        Data data


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ResponseObj{")
            sb.append("id='").append(id).append('\'')
            sb.append(", href='").append(href).append('\'')
            sb.append(", status='").append(status).append('\'')
            sb.append(", message='").append(message).append('\'')
            sb.append(", data=").append(data)
            sb.append('}')
            return sb.toString()
        }
    }

    static class Data {
        Map<String,Object> details

        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("Data{")
            sb.append("details={")
            for(String key:details.keySet())
            {
                sb.append('\'').append(key).append('\':[')
                sb.append((String) details.get(key))
                sb.append('],')
            }
            sb.append('}')
            sb.append('}')
            return sb.toString()
        }
    }

    static class CallbackRequest {
        String orderId
        int resultCode
        String resultMessage

        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("CallbackRequest{")
            sb.append("orderId='").append(orderId).append('\'')
            sb.append(", resultCode=").append(resultCode)
            sb.append(", resultMessage='").append(resultMessage).append('\'')
            sb.append('}')
            return sb.toString()
        }

    }

    static class CallbackResponse {
        int resultCode
        String resultMessage

        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("CallbackResponse{")
            sb.append("resultCode=").append(resultCode)
            sb.append(", resultMessage='").append(resultMessage).append('\'')
            sb.append('}')
            return sb.toString()
        }

    }

    static class PaymentDeclarationRequest {
        String id
        String paymentDate
        String description
        String distributorCode
        PurchaseDetails purchaseDetails
        Channel channel
        PaymentMethod paymentMethod

        static class PurchaseDetails {
            String id
            String amount
        }

        static class Channel {
            String id
            String name
        }

        static class PaymentMethod {
            String preference
            Details details
            static class Details {
                String from
                String to
                String extra_1
                String extra_2
            }
        }

        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ResponseObj{")
            sb.append("id=").append(id)
            sb.append(", paymentDate='").append(paymentDate).append('\'')
            sb.append(", description='").append(description).append('\'')
            sb.append(", distributorCode='").append(distributorCode).append('\'')
            sb.append(", purchaseDetails={id='").append(purchaseDetails.id).append('\'')
            sb.append(", amount='").append(purchaseDetails.amount).append('\'}')
            sb.append(", channel={id='").append(channel.id).append('\'')
            sb.append(", name='").append(channel.name).append('\'}')
            sb.append(", paymentMethod={preference='").append(paymentMethod.preference).append('\'')
            sb.append(", details={from='").append(paymentMethod.details.from).append('\'')
            sb.append(", to='").append(paymentMethod.details.to).append('\'')
            sb.append(", extra_1='").append(paymentMethod.details.extra_1).append('\'')
            sb.append(", extra_2='").append(paymentMethod.details.extra_2).append('\'}}')
            sb.append('}')
            return sb.toString()
        }
    }
}

