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
import java.math.BigDecimal

class ERP_CREATE_MONEY_RECEIPT_FOR_DUMMY_PO extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(ERP_CREATE_MONEY_RECEIPT_FOR_DUMMY_PO.class)
    private static final String RESPONSE_BODY = "RESPONSE_BODY"
    private static final String EXTERNAL_CALL_RESULT_CODE = "EXTERNAL_CALL_RESULT_CODE"

    private static final String erpMoneyReceiptUrl = "http://svc-idm-erp-link:15700/erplink/moneyReceipts"
    private static final String callbackUrl = "http://svc-order-management:9595/oms/v2/notify-of-money-receipt-creation"

    private static final String TASK = ERP_CREATE_MONEY_RECEIPT_FOR_DUMMY_PO.class.name

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
            log.info("{} - MONEY RECEIPT PAYLOAD: {}", TASK, payload)
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
            
            log.info("{} - Making POST request to URL: {}", TASK, erpMoneyReceiptUrl)
            ResponseEntity<String> responseEntity = restTemplate.exchange(erpMoneyReceiptUrl, HttpMethod.POST, requestEntity, String.class)
            
            log.info("{} - Received response with status code: {}", TASK, responseEntity.statusCode)
            log.info("{} - Response body: {}", TASK, responseEntity.getBody())
            transaction.getLinkActionInProgress().setResponse(responseEntity.getBody())
            
            if (responseEntity.statusCode == HttpStatus.OK) {
                log.info("{} - Response status code is OK (200), processing response", TASK)
                MoneyReceiptResponse responseObj = gson.fromJson(responseEntity.getBody(), MoneyReceiptResponse.class)
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
            log.error("{} - Error making API call: {}", TASK, e.getMessage())
            throw new ActionProcessingException("Error making API call: " + e.getMessage())
        }
    }

    @Override
    void handleResponse(HelperTransaction transaction) {
        log.info("{} - Parsing response for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
        try {
            // Add any response handling logic here
            log.info("Handling response... Nothing to do")
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

            final MoneyReceiptRequest moneyReceiptRequest = gson.fromJson(requestPayload, MoneyReceiptRequest.class)
            final String responsePayload = transaction.getLinkActionInProgress().getResponse()
            final MoneyReceiptResponse moneyReceiptResponse = gson.fromJson(responsePayload, MoneyReceiptResponse.class)

            log.info("{} - Order ID: [{}] for requestId: {} with inboundTxnId: {}", TASK, moneyReceiptRequest.orderId, requestId, inboundTxnId)
            log.info("{} - External Call ResultCode: [{}] for requestId: {} with inboundTxnId: {}", TASK, moneyReceiptResponse.resultCode, requestId, inboundTxnId)
            log.info("{} - External Call Success Status: [{}] for requestId: {} with inboundTxnId: {}", TASK, transaction.isExternalCallSuccess(), requestId, inboundTxnId)
            log.info("{} - External Call Response Message: [{}] for requestId: {} with inboundTxnId: {}", TASK, transaction.getExternalCallResultDescription(), requestId, inboundTxnId)

            if (moneyReceiptResponse.resultCode == 0) {
                log.info("{} - Preparing callback request for order ID: {}", TASK, moneyReceiptRequest.orderId)
                final CallbackRequest callbackRequest = new CallbackRequest(
                    orderId: moneyReceiptRequest.orderId,
                    resultCode: 0,
                    resultMessage: "SUCCESS",
                        data: moneyReceiptResponse.getData()
                )
                
                final HttpHeaders headers = getHttpHeaders(systemToken, authorization)
                final HttpEntity<CallbackRequest> callbackRequestEntity = new HttpEntity<>(callbackRequest, headers)
                
                log.info("{} - Making callback request to URL: {}", TASK, callbackUrl)
                final ResponseEntity<CallbackResponse> callbackResponseEntity = restTemplate.exchange(
                    callbackUrl,
                    HttpMethod.POST,
                    callbackRequestEntity,
                    CallbackResponse.class
                )
                
                if (callbackResponseEntity.statusCode != HttpStatus.OK) {
                    log.error("{} - Callback returned non-200 response code: {}", TASK, callbackResponseEntity.statusCode)
                    throw new ActionProcessingException("Callback returned non-200 response code")
                }

                final CallbackResponse callbackResponseBody = callbackResponseEntity.body
                if (callbackResponseBody == null) {
                    log.error("{} - Null response received from callback", TASK)
                    throw new ActionProcessingException("Null response received from callback")
                }

                if (callbackResponseBody.resultCode != 0) {
                    log.error("{} - Callback failed with result code: [{}] and message: [{}]", TASK, callbackResponseBody.resultCode, callbackResponseBody.resultMessage)
                    throw new ActionProcessingException(String.format("Callback failed with result code: [%d] and message: [%s]", callbackResponseBody.resultCode, callbackResponseBody.resultMessage))
                }

                log.info("{} - Callback executed successfully for order ID: {}", TASK, moneyReceiptRequest.orderId)
            } else {
                log.error("{} - Money receipt creation failed with result code: [{}] and message: [{}]", TASK, moneyReceiptResponse.resultCode, moneyReceiptResponse.resultMessage)
                throw new ActionProcessingException(String.format("Money receipt creation failed with result code: [%d] and message: [%s]", moneyReceiptResponse.resultCode, moneyReceiptResponse.resultMessage))
            }
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

    static class MoneyReceiptRequest {
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

        @Override
        String toString() {
            return "MoneyReceiptRequest{" +
                    "orderId='" + orderId + '\'' +
                    ", buyerId='" + buyerId + '\'' +
                    ", receiptNumber='" + receiptNumber + '\'' +
                    ", businessUnit='" + businessUnit + '\'' +
                    ", receiptMethod='" + receiptMethod + '\'' +
                    ", receiptDate='" + receiptDate + '\'' +
                    ", amount=" + amount +
                    ", currency='" + currency + '\'' +
                    ", remittanceBankAccountNumber='" + remittanceBankAccountNumber + '\'' +
                    ", customerAccountNumber='" + customerAccountNumber + '\'' +
                    ", accountingDate='" + accountingDate + '\'' +
                    ", remittanceReferences=" + remittanceReferences +
                    '}'
        }
    }

    static class RemittanceReference {
        String receiptMatchBy
        String referenceNumber
        BigDecimal referenceAmount

        @Override
        String toString() {
            return "RemittanceReference{" +
                    "receiptMatchBy='" + receiptMatchBy + '\'' +
                    ", referenceNumber='" + referenceNumber + '\'' +
                    ", referenceAmount=" + referenceAmount +
                    '}'
        }
    }

    static class MoneyReceiptResponse {
        int resultCode
        String resultMessage
        MoneyReceiptData data

        @Override
        String toString() {
            return "MoneyReceiptResponse{" +
                    "resultCode=" + resultCode +
                    ", resultMessage='" + resultMessage + '\'' +
                    ", data=" + data +
                    '}'
        }
    }

    static class MoneyReceiptData {
        Integer standardReceiptId
        String receiptNumber

        @Override
        String toString() {
            return "MoneyReceiptData{" +
                    "standardReceiptId=" + standardReceiptId +
                    ", receiptNumber='" + receiptNumber + '\'' +
                    '}'
        }
    }

    static class CallbackRequest {
        String orderId
        int resultCode
        String resultMessage
        MoneyReceiptData data

        @Override
        public String toString() {
            return "CallbackRequest{" +
                    "orderId='" + orderId + '\'' +
                    ", resultCode=" + resultCode +
                    ", resultMessage='" + resultMessage + '\'' +
                    ", data=" + data +
                    '}';
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