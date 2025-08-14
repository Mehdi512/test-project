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

class ERP_RESERVE_INVENTORY extends AbstractAction {
    private static final Logger log = LoggerFactory.getLogger(ERP_RESERVE_INVENTORY.class)
    private static final String RESPONSE_BODY = "RESPONSE_BODY"
    private static final String EXTERNAL_CALL_RESULT_CODE = "EXTERNAL_CALL_RESULT_CODE"

    private static final String erpReserveUrl = "http://svc-idm-erp-link:15700/erplink/standardReceipts"
    private static final String callbackUrl = "http://svc-order-management:9595/oms/v2/order/confirm-inventory-reservation"

    private static final String TASK = ERP_RESERVE_INVENTORY.class.name

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
            log.info("ERP RESERVE INVENTORY PAYLOAD: {}", TASK, payload)
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
            
            log.info("{} - Making POST request to URL: {}", TASK, erpReserveUrl)
            ResponseEntity<String> responseEntity = restTemplate.exchange(erpReserveUrl, HttpMethod.POST, requestEntity, String.class)
            
            log.info("{} - Received response with status code: {}", TASK, responseEntity.statusCode)
            log.info("{} - Response body: {}", TASK, responseEntity.getBody())
            transaction.getLinkActionInProgress().setResponse(responseEntity.getBody())
            
            if (responseEntity.statusCode == HttpStatus.OK) {
                log.info("{} - Response status code is OK (200), processing response", TASK)
                ERPSerialNumberResponse responseObj = gson.fromJson(responseEntity.getBody(), ERPSerialNumberResponse.class)
                log.debug("{} - Unmarshalled response object: {}", TASK, responseObj.toString())
                
                if (responseObj == null) {
                    log.error("{} - Null response object received from remote endpoint", TASK)
                    transaction.setExternalCallSuccess(false)
                    throw new ActionProcessingException("Null response received from remote endpoint")
                }
                
                // Check if all parts have reservation IDs
                boolean allPartsHaveReservationIds = true
                for (ResponseDetailObject part : responseObj.parts) {
                    if (!part.payload || !part.payload.reservationId) {
                        allPartsHaveReservationIds = false
                        log.error("{} - Part with ID {} is missing reservation ID", TASK, part.id)
                        break
                    }
                }
                
                log.info("{} - Setting external call success to: {}", TASK, allPartsHaveReservationIds)
                transaction.setExternalCallSuccess(allPartsHaveReservationIds)
                
                if (!transaction.isExternalCallSuccess()) {
                    log.error("{} - Transaction failed: Not all parts have reservation IDs", TASK)
                    throw new ActionProcessingException("Not all parts have reservation IDs")
                } else if (responseObj.parts == null) {
                    log.warn("{} - Transaction successful but with parts equal to null", TASK)
                } else {
                    log.info("{} - Transaction successful with {} parts having reservation IDs", TASK, responseObj.parts.size())
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
        // According to the LLD, IDM (OMS in this case) does not need the info returned from the ERP,
        // hence, a callback is not necessary

//        log.info("{} - Executing callback for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
//        try {
//            ERPSerialNumberRequest request = gson.fromJson(transaction.getLinkActionInProgress().getRequest(), ERPSerialNumberRequest.class)
//            String requestId = transaction.getInboundRequest().getId()
//            String inboundTxId = transaction.getInboundRequest().getInboundTxnId()
//            String systemToken = transaction.getInboundRequest().getToken()
//            String authorization = transaction.getInboundRequest().getAuthorization()
//
//            String response = transaction.getLinkActionInProgress().getResponse()
//            ERPSerialNumberResponse responseObj = gson.fromJson(response, ERPSerialNumberResponse.class)
//
//            log.info("{} - Request Type: [{}] for requestId: {} with inboundTxnId: {}", TASK, transaction.getInboundRequest().operationType, requestId, inboundTxId)
//            int numberOfParts = request.parts == null ? 0 : request.parts.size()
//            log.info("{} - Parts Count: [{}] for requestId: {} with inboundTxnId: {}", TASK, numberOfParts, requestId, inboundTxId)
//            log.info("{} - External Call Success Status: [{}] for requestId: {} with inboundTxnId: {}", TASK, transaction.isExternalCallSuccess(), requestId, inboundTxId)
//
//            if (transaction.isExternalCallSuccess()) {
//                log.info("{} - Preparing callback request for {} parts", TASK, numberOfParts)
//                CallbackRequest callbackRequest = new CallbackRequest()
//                callbackRequest.setOrderId(request.parts == null ? "" : request.parts[0].id) // Use first part ID as reference if there is one
//                callbackRequest.setResultCode(0)
//                callbackRequest.setResultMessage("SUCCESS")
//
//                HttpHeaders headers = getHttpHeaders(systemToken, authorization)
//                HttpEntity<CallbackRequest> callbackRequestHttpEntity = new HttpEntity<>(callbackRequest, headers)
//
//                log.info("{} - Making callback request to URL: {}", TASK, callbackUrl)
//                ResponseEntity<String> callbackResponse = restTemplate.exchange(callbackUrl, HttpMethod.POST, callbackRequestHttpEntity, String.class)
//
//                if (callbackResponse.statusCode != HttpStatus.OK) {
//                    log.error("{} - Callback returned non-200 response code: {}", TASK, callbackResponse.statusCode)
//                    throw new ActionProcessingException("Callback returned non-200 response code")
//                } else {
//                    log.info("{} - Callback response: {}", TASK, callbackResponse.getBody())
//                    CallbackResponse resp = gson.fromJson(callbackResponse.getBody(), CallbackResponse.class)
//                    if (resp == null) {
//                        log.error("{} - Callback response was null", TASK)
//                        throw new ActionProcessingException("Callback response was null")
//                    }
//                    if (resp.resultCode != 0) {
//                        log.error("{} - Callback returned non-zero response code: {}", TASK, resp.resultCode)
//                        throw new ActionProcessingException("Callback returned non-zero response code")
//                    }
//                    log.info("{} - Callback completed successfully for {} parts", TASK, request.parts.size())
//                }
//            } else {
//                log.error("{} - Transaction failed: Not all parts have reservation IDs", TASK)
//                throw new ActionProcessingException("Not all parts have reservation IDs")
//            }
//        } catch (Exception e) {
//            log.error("{} - Exception occurred during callback", TASK, e)
//            LinkActionErrorReason errorReason = new LinkActionErrorReason()
//            errorReason.setLinkAction(transaction.getLinkActionInProgress())
//            errorReason.setReason(e.getMessage())
//            linkActionErrorReasonService.save(errorReason)
//            transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_CALLBACK)
//            throw e
//        }
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

    static class ERPSerialNumberRequest {
        List<DetailObject> parts

        @Override
        String toString() {
            return "ERPSerialNumberRequest{" +
                    "parts=" + parts +
                    '}'
        }
    }

    static class DetailObject {
        String id
        String path
        String operation
        Payload payload

        @Override
        String toString() {
            return "DetailObject{" +
                    "id='" + id + '\'' +
                    ", path='" + path + '\'' +
                    ", operation='" + operation + '\'' +
                    ", payload=" + payload +
                    '}'
        }
    }

    static class Payload {
        String itemNumber
        String organizationId
        String demandSourceType
        String demandSourceName
        String supplySourceType
        String demandSourceHeaderNumber
        String demandSourceLineNumber
        String reservationUnitOfMeasure
        String subinventoryCode
        Integer reservationQuantity
        List<Integer> serials
        String lotNumber

        @Override
        String toString() {
            return "Payload{" +
                    "itemNumber='" + itemNumber + '\'' +
                    ", organizationId='" + organizationId + '\'' +
                    ", demandSourceType='" + demandSourceType + '\'' +
                    ", demandSourceName='" + demandSourceName + '\'' +
                    ", supplySourceType='" + supplySourceType + '\'' +
                    ", demandSourceHeaderNumber='" + demandSourceHeaderNumber + '\'' +
                    ", demandSourceLineNumber='" + demandSourceLineNumber + '\'' +
                    ", reservationUnitOfMeasure='" + reservationUnitOfMeasure + '\'' +
                    ", subinventoryCode='" + subinventoryCode + '\'' +
                    ", reservationQuantity=" + reservationQuantity +
                    ", serials=" + serials +
                    ", lotNumber='" + lotNumber + '\'' +
                    '}'
        }
    }

    static class ERPSerialNumberResponse {
        List<ResponseDetailObject> parts

        @Override
        String toString() {
            return "ERPSerialNumberResponse{" +
                    "parts=" + parts +
                    '}'
        }
    }

    static class ResponseDetailObject {
        String id
        ResponsePayload payload

        @Override
        String toString() {
            return "ResponseDetailObject{" +
                    "id='" + id + '\'' +
                    ", payload=" + payload +
                    '}'
        }
    }

    static class ResponsePayload {
        String reservationId

        @Override
        String toString() {
            return "ResponsePayload{" +
                    "reservationId='" + reservationId + '\'' +
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