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

class BPRS_DEFAULTERS_NOTIFICATION extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(BPRS_DEFAULTERS_NOTIFICATION.class)
    private static final String RESPONSE_BODY = "RESPONSE_BODY"
    private static final String EXTERNAL_CALL_RESULT_CODE = "EXTERNAL_CALL_RESULT_CODE"

    private static final String defaultersUrl = "http://svc-idm-bprs-link:15800/bprslink/oms/defaulters-notification"
    private static final String callbackUrl = "http://svc-order-management:9595/oms/v2/order/confirm-defaulters-notification"

    private static final String TASK = BPRS_DEFAULTERS_NOTIFICATION.class.name

    @Override
    void evaluatePreConditions(HelperTransaction transaction) {
        log.info("{} - Checking preconditions for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            // Add any precondition checks here
        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }

    @Override
    void validateRequest(HelperTransaction transaction) {
        log.info("{} implementation - Validating request for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            String payload = transaction.getInboundRequest().getPayload()
            log.info("BPRS DEFAULTERS NOTIFICATION PAYLOAD: {}", payload)
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

            log.info("{} - Preparing API call with request: {}", TASK, request)
            log.debug("{} - System token: {}, Authorization: {}", TASK, systemToken, authorization)

            HttpHeaders headers = getHttpHeaders(systemToken, authorization)
            HttpEntity<String> requestEntity = new HttpEntity<>(request, headers)

            log.info("{} - Making POST request to URL: {}", TASK, defaultersUrl)
            ResponseEntity<String> responseEntity = restTemplate.exchange(defaultersUrl, HttpMethod.POST, requestEntity, String.class)

            log.info("{} - Received response with status code: {}", TASK, responseEntity.statusCode)
            log.info("{} - Response body: {}", TASK, responseEntity.getBody())
            transaction.getLinkActionInProgress().setResponse(responseEntity.getBody())

            if (responseEntity.statusCode == HttpStatus.OK) {
                log.info("{} - Response status code is OK (200), processing response", TASK)
                ResponseObj responseObj = gson.fromJson(responseEntity.getBody(), ResponseObj.class)
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
                    throw new ActionProcessingException(String.format("transaction failed with result code: [%d] and description: [%s]", responseObj?.resultCode, responseObj?.resultMessage))
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
        log.info("{} implementation - Parsing response for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            // Add any response handling logic here
        } catch (ActionProcessingException e) {
            log.error("{} implementation - Error parsing response", TASK, e)
            LinkActionErrorReason errorReason = new LinkActionErrorReason()
            errorReason.setLinkAction(transaction.getLinkActionInProgress())
            errorReason.setReason(String.format("DEBUG Point %s implementation", TASK))
            linkActionErrorReasonService.save(errorReason)
            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_HANDLE_RESPONSE)
            throw e
        } catch (InterruptedException e) {
            log.error("{} implementation - Thread interrupted", TASK, e)
        }
    }

    @Override
    void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
        // Add any response data extraction logic here
    }

    @Override
    void callback(HelperTransaction transaction) {
        log.info("{} implementation - Executing callback for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            DefaultersNotificationRequest request = gson.fromJson(transaction.getLinkActionInProgress().getRequest(), DefaultersNotificationRequest.class)
            String requestId = transaction.getInboundRequest().getId()
            String inboundTxId = transaction.getInboundRequest().getInboundTxnId()
            String systemToken = transaction.getInboundRequest().getToken()
            String authorization = transaction.getInboundRequest().getAuthorization()

            String response = transaction.getLinkActionInProgress().getResponse()
            ResponseObj responseObj = gson.fromJson(response, ResponseObj.class)

            log.info("{} - Request Type: [{}] for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().operationType, requestId, inboundTxId)
            log.info("{} - PO Number: [{}] for requestId: {} with inboundTxnId: {}", TASK, request.poNo, requestId, inboundTxId)
            log.info("{} - External Call ResultCode: [{}] for requestId: {} with inboundTxnId: {}", TASK, responseObj.resultCode, requestId, inboundTxId)
            log.info("{} - External Call Success Status: [{}] for requestId: {} with inboundTxnId: {}", TASK, transaction.isExternalCallSuccess(), requestId, inboundTxId)
            log.info("{} - External Call Response Message: [{}] for requestId: {} with inboundTxnId: {}", TASK, transaction.getExternalCallResultDescription(), requestId, inboundTxId)

            if (responseObj.resultCode == 0) {
                log.info("{} - Preparing callback request for PO number: {}", TASK, request.poNo)
                CallbackRequest callbackRequest = new CallbackRequest()
                callbackRequest.setOrderId(request.poNo)
                callbackRequest.setResultCode(0)
                callbackRequest.setResultMessage("SUCCESS")

                HttpHeaders headers = getHttpHeaders(systemToken, authorization)
                HttpEntity<CallbackRequest> callbackRequestHttpEntity = new HttpEntity<>(callbackRequest, headers)

                log.info("{} - Making callback request to URL: {}", TASK, callbackUrl)
                ResponseEntity<String> callbackResponse = restTemplate.exchange(callbackUrl, HttpMethod.POST, callbackRequestHttpEntity, String.class)

                if (callbackResponse.statusCode != HttpStatus.OK) {
                    log.error("{} - Callback returned non-200 response code: {}", TASK, callbackResponse.statusCode)
                    throw new ActionProcessingException("Callback returned non-200 response code")
                } else {
                    log.info("{} - Callback response: {}", TASK, callbackResponse.getBody())
                    CallbackResponse resp = gson.fromJson(callbackResponse.getBody(), CallbackResponse.class)
                    if (resp == null) {
                        log.error("{} - Callback response was null", TASK)
                        throw new ActionProcessingException("Callback response was null")
                    }
                    if (resp.resultCode != 0) {
                        log.error("{} - Callback returned non-zero response code: {}", TASK, resp.resultCode)
                        throw new ActionProcessingException("Callback returned non-zero response code")
                    }
                    log.info("{} - Callback completed successfully for PO number: {}", TASK, request.poNo)
                }
            } else {
                log.error("{} - Transaction failed with result code: [{}] and description: [{}]", TASK, responseObj?.resultCode, responseObj?.resultMessage)
                throw new ActionProcessingException(String.format("transaction failed with result code: [%d] and description: [%s]", responseObj?.resultCode, responseObj?.resultMessage))
            }
        } catch (Exception e) {
            log.error("{} - Exception occurred during callback", TASK, e)
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

    static class DefaultersNotificationRequest {
        String poNo
        String poDate
        BigDecimal amount
        String poType = "Credit"
        String paymentMethod = ""
        String customerERPCode
        String regionName
        String distName
        String distCode
        String userInfo
        String note = ""
        String customerDMSCode
        String mrNo = ""
        String instrumentNo = ""
        String paymentRefundDate

        @Override
        String toString() {
            return "DefaultersNotificationRequest{" +
                    "poNo='" + poNo + '\'' +
                    ", poDate='" + poDate + '\'' +
                    ", amount=" + amount +
                    ", poType='" + poType + '\'' +
                    ", paymentMethod='" + paymentMethod + '\'' +
                    ", customerERPCode='" + customerERPCode + '\'' +
                    ", regionName='" + regionName + '\'' +
                    ", distName='" + distName + '\'' +
                    ", distCode='" + distCode + '\'' +
                    ", userInfo='" + userInfo + '\'' +
                    ", note='" + note + '\'' +
                    ", customerDMSCode='" + customerDMSCode + '\'' +
                    ", mrNo='" + mrNo + '\'' +
                    ", instrumentNo='" + instrumentNo + '\'' +
                    ", paymentRefundDate='" + paymentRefundDate + '\'' +
                    '}'
        }
    }

    static class ResponseObj {
        int resultCode
        String resultMessage
        Data data

        @Override
        String toString() {
            return "ResponseObj{" +
                    "resultCode=" + resultCode +
                    ", resultMessage='" + resultMessage + '\'' +
                    ", data=" + data +
                    '}'
        }
    }

    static class Data {
        Map<String, Object> details

        @Override
        String toString() {
            return "Data{" +
                    "details=" + details +
                    '}'
        }
    }

    static class CallbackRequest {
        String orderId
        int resultCode
        String resultMessage

        @Override
        String toString() {
            return "CallbackRequest{" +
                    "orderId='" + orderId + '\'' +
                    ", resultCode=" + resultCode +
                    ", resultMessage='" + resultMessage + '\'' +
                    '}'
        }
    }

    static class CallbackResponse {
        int resultCode
        String resultMessage

        @Override
        String toString() {
            return "CallbackResponse{" +
                    "resultCode=" + resultCode +
                    ", resultMessage='" + resultMessage + '\'' +
                    '}'
        }
    }
}