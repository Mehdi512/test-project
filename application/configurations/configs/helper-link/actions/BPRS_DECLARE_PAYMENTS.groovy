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

import java.text.SimpleDateFormat

class BPRS_DECLARE_PAYMENTS extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(BPRS_DECLARE_PAYMENTS.class)
    private static final String RESPONSE_BODY = "RESPONSE_BODY"
    private static final String EXTERNAL_CALL_RESULT_CODE = "EXTERNAL_CALL_RESULT_CODE"

    private static final String paymentUrl = "http://svc-idm-bprs-link:15800/bprslink/oms/payment-request"
    private static final String callbackUrl = "http://svc-order-management:9595/oms/v2/order/confirm-payment-submission"

    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")

    private static final String TASK = BPRS_DECLARE_PAYMENTS.class.name


    @Override
    void evaluatePreConditions(HelperTransaction transaction) {
        log.info("{} - Checking preconditions for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
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
            log.info("BPRS PAYLOAD: {}", payload)
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
            PaymentDeclarationRequest request = gson.fromJson(payload, PaymentDeclarationRequest.class)
            //convert date
            long dateValue = Long.parseLong(request.poDate)
            request.poDate = dateFormat.format(dateValue)
            String requestString = gson.toJson(request)
            transaction.getLinkActionInProgress().setRequest(requestString)
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
            ResponseEntity<String> responseEntity  = restTemplate.exchange(paymentUrl, HttpMethod.POST, requestEntity, String.class)
            log.info("Response received from BPRSLink: [{}]", responseEntity.getBody())
            transaction.getLinkActionInProgress().setResponse(responseEntity.getBody())
            if(responseEntity.statusCode == HttpStatus.OK){
                ResponseObj responseObj = gson.fromJson(responseEntity.getBody(), ResponseObj.class)
                log.debug("unmarshalled response: {}",responseObj.toString())
                if(responseObj == null)
                {
                    transaction.setExternalCallSuccess(false)
                    throw new ActionProcessingException("Null response received from remote endpoint")
                }
                transaction.setExternalCallSuccess(responseObj.resultCode == 0)
                if(!transaction.isExternalCallSuccess())
                {
                    log.error("transaction failed with result code: [{}] and description: [{}]", responseObj?.resultCode, responseObj?.resultMessage)
                    throw new ActionProcessingException(String.format("transaction failed with result code: [%d] and description: [%s]", responseObj?.resultCode, responseObj?.resultMessage))
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

            PaymentDeclarationRequest request =  gson.fromJson(transaction.getLinkActionInProgress().getRequest(), PaymentDeclarationRequest.class)
            String requestId = transaction.getInboundRequest().getInboundTxnId()
            String inboundTxId = transaction.getInboundRequest().getInboundTxnId()
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()

            String response = transaction.getLinkActionInProgress().getResponse()
            ResponseObj responseObj =  gson.fromJson(response, ResponseObj.class)

            log.info("Request Type: [{}] for requestId: {} with inboundTxnId: {}", transaction.getInboundRequest().operationType, requestId, inboundTxId)
            log.info("Order ID: [{}] for requestId: {} with inboundTxnId: {}", request.poNo, requestId, inboundTxId)
            log.info("External Call ResultCode: [{}] for requestId: {} with inboundTxnId: {}", responseObj.resultCode, requestId, inboundTxId)
            log.info("External Call Success Status:  [{}] for requestId: {} with inboundTxnId: {}", transaction.isExternalCallSuccess(), requestId, inboundTxId)
            log.info("External Call Response Message: [{}] for requestId: {} with inboundTxnId: {}", transaction.getExternalCallResultDescription(), requestId, inboundTxId)
            log.debug("System token: {}", systemToken)
            log.info("Authorization: {}", authorization)

            if(responseObj.resultCode == 0)
            {
                CallbackRequest callbackRequest = new CallbackRequest()
                callbackRequest.setOrderId(request.poNo)
                callbackRequest.setResultCode(0)
                callbackRequest.setResultMessage("SUCCESS")
                HttpHeaders headers = getHttpHeaders(systemToken, authorization)
                HttpEntity<CallbackRequest> callbackRequestHttpEntity = new HttpEntity<>(callbackRequest, headers)
                ResponseEntity<String> callbackResponse = restTemplate.exchange(callbackUrl, HttpMethod.POST, callbackRequestHttpEntity, String.class)
                if(callbackResponse.statusCode != HttpStatus.OK){
                    throw new ActionProcessingException("Callback returned non-200 response code")
                } else {
                   log.info("Callback response: {}",  callbackResponse.getBody())
                    CallbackResponse resp = gson.fromJson(callbackResponse.getBody(), CallbackResponse.class)
                    if(resp == null){
                        throw new ActionProcessingException("Callback response was null")
                    }
                    if(resp.resultCode != 0){
                        throw new ActionProcessingException("Callback returned non-zero response code")
                    }
                }

            }
            else
            {
                //this branch should not get invoked as this condition is handled already in makeApiCall. It's here so something gets logged
                //if some refactoring accidentally breaks something
                log.error("transaction failed with result code: [{}] and description: [{}]", responseObj?.resultCode, responseObj?.resultMessage)
                throw new ActionProcessingException(String.format("transaction failed with result code: [%d] and description: [%s]", responseObj?.resultCode, responseObj?.resultMessage))
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


    HttpHeaders getHttpHeaders(String systemToken, String authorization)
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

    static class ResponseObj {
        int resultCode
        String resultMessage
        Data data


        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("ResponseObj{");
            sb.append("resultCode=").append(resultCode);
            sb.append(", resultMessage='").append(resultMessage).append('\'');
            sb.append(", data=").append(data);
            sb.append('}');
            return sb.toString();
        }
    }

    static class Data {
        String statusCode
        String statusMessage

        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("Data{");
            sb.append("statusCode='").append(statusCode).append('\'');
            sb.append(", statusMessage='").append(statusMessage).append('\'');
            sb.append('}');
            return sb.toString();
        }
    }

    static class CallbackRequest {
        String orderId
        int resultCode
        String resultMessage

        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("CallbackRequest{");
            sb.append("orderId='").append(orderId).append('\'');
            sb.append(", resultCode=").append(resultCode);
            sb.append(", resultMessage='").append(resultMessage).append('\'');
            sb.append('}');
            return sb.toString();
        }
    }

    static class CallbackResponse {
        int resultCode
        String resultMessage

        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("CallbackResponse{");
            sb.append("resultCode=").append(resultCode);
            sb.append(", resultMessage='").append(resultMessage).append('\'');
            sb.append('}');
            return sb.toString();
        }
    }

    static class PaymentDeclarationRequest {
        String poNo
        String poDate
        String amount
        String poType
        String paymentMethod
        String customerERPCode
        String regionName
        String distName
        String distCode
        String userInfo
        String note
        String customerDMSCode
        String mrNo
        String instrumentNo

        @Override
        String toString() {
            final StringBuilder sb = new StringBuilder("PaymentDeclarationRequest{");
            sb.append("poNo='").append(poNo).append('\'');
            sb.append(", poDate='").append(poDate).append('\'');
            sb.append(", amount=").append(amount);
            sb.append(", poType='").append(poType).append('\'');
            sb.append(", paymentMethod='").append(paymentMethod).append('\'');
            sb.append(", customerERPCode='").append(customerERPCode).append('\'');
            sb.append(", regionName='").append(regionName).append('\'');
            sb.append(", distName='").append(distName).append('\'');
            sb.append(", distCode='").append(distCode).append('\'');
            sb.append(", userInfo='").append(userInfo).append('\'');
            sb.append(", note='").append(note).append('\'');
            sb.append(", customerDMSCode='").append(customerDMSCode).append('\'');
            sb.append(", mrNo='").append(mrNo).append('\'');
            sb.append(", instrumentNo='").append(instrumentNo).append('\'');
            sb.append('}');
            return sb.toString();
        }
    }


}
