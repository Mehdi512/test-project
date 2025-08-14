package se.seamless.idm.actions.impl

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.springframework.web.client.HttpClientErrorException
import groovy.transform.CompileStatic
import com.seamless.common.transaction.SystemToken
import java.util.concurrent.atomic.AtomicBoolean

import se.seamless.idm.actions.AbstractAction
import se.seamless.idm.enums.LinkActionStatus
import se.seamless.idm.exceptions.ActionProcessingException
import se.seamless.idm.exceptions.FailedAtExternalSystemException
import se.seamless.idm.exceptions.PayloadParsingException
import se.seamless.idm.exceptions.RetriableException
import se.seamless.idm.model.HelperTransaction
import com.fasterxml.jackson.core.type.TypeReference
import com.fasterxml.jackson.databind.ObjectMapper

import java.util.Arrays
import java.util.HashMap
import java.util.HashSet
import java.util.Map
import java.util.Objects
import java.util.Set
import java.lang.Integer

@CompileStatic
class ERSPinChangeAction extends AbstractAction {
	private static final Logger log = LoggerFactory.getLogger(ERSPinChangeAction.class)
	private final AtomicBoolean initialized = new AtomicBoolean(false);

	private String API_ENDPOINT;
	private String RETRY_DELAY_MS;
	private String STATUS_CODE;
	private String MESSAGE;
	private List<String> RETRIABLE_STATUS_CODES;
	private List<String> SUCCESS_STATUS_CODES;

	@Override
	protected void loadActionData(HelperTransaction transaction) {
		if (!initialized.getAndSet(true)) {
			log.info("Loading action data for " + ERSPinChangeAction + ", requestId: {}", transaction.getInboundRequest().getId());
			API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-idm-ers-link:15500/erslink/v1/pin-change");
			RETRY_DELAY_MS = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", "1000");
			STATUS_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "STATUS_CODE", "txnstatus");
			MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "MESSAGE", "message");
			RETRIABLE_STATUS_CODES = actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "RETRIABLE_STATUS_CODES", Arrays.asList("500", "400"));
			SUCCESS_STATUS_CODES = actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "SUCCESS_STATUS_CODES", Arrays.asList("200", "205"));
			log.info("Action data loaded: API_ENDPOINT={}, RETRY_DELAY_MS={}, STATUS_CODE={}, MESSAGE={}, RETRIABLE_STATUS_CODES={}, SUCCESS_STATUS_CODES={}",
					API_ENDPOINT, RETRY_DELAY_MS, STATUS_CODE, MESSAGE, RETRIABLE_STATUS_CODES, SUCCESS_STATUS_CODES);
		}
		transaction.setDefaultRetryDelayMs(Integer.parseInt(RETRY_DELAY_MS));
	}

	@Override
	protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException {
		log.debug("No pre-conditions defined for requestId: {} with inboundTxnId: {}",
				transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
	}

	@Override
	protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException {
		log.info("No validation defined for requestId: {} with inboundTxnId: {}",
				transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
	}

	@Override
	protected void createRequest(HelperTransaction transaction) throws ActionProcessingException {
		log.info("Started creation of request for requestId: {} with inboundTxnId: {}",
				transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
		try {
			String jsonRequest = createJsonRequestString(transaction.getInboundRequest().getPayload(),
					commonUtils.getSystemToken(transaction.getInboundRequest().getToken()), transaction)
			transaction.getLinkActionInProgress().setRequest(jsonRequest)
			log.debug("Created JSON request: {}", jsonRequest)
		} catch (Exception e) {
			log.error("Failed to create JSON request", e)
			throw new ActionProcessingException("Failed to create JSON request: " + e.getMessage())
		}
	}

	@Override
	protected void makeApiCall(HelperTransaction transaction) throws RetriableException {
		String jsonRequest = transaction.getLinkActionInProgress().getRequest()
		HttpEntity<String> requestEntity = buildHttpEntity(jsonRequest, transaction.getInboundRequest().getToken())

		try {
			String response = restTemplate.postForObject(API_ENDPOINT, requestEntity, String.class)
			transaction.getLinkActionInProgress().setResponse(response)
		} catch (HttpClientErrorException.BadRequest e) {
			log.error("Failed to make API call", e)
			throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL)
		}
	}

	@Override
	protected void handleResponse(HelperTransaction transaction) throws ActionProcessingException, FailedAtExternalSystemException, PayloadParsingException, RetriableException {
		if(Objects.isNull(transaction.getLinkActionInProgress().getResponse())) {
			log.error("NULL response from ERS link")
			throw new FailedAtExternalSystemException("NULL response from ERS link")
		}
		Map<String, Object> responseMap = commonUtils.convertObjectToMap(transaction.getLinkActionInProgress().getResponse())
		if(!responseMap.containsKey(STATUS_CODE)) {
			log.error("Invalid response from ERS link: {}", responseMap)
			throw new ActionProcessingException("Invalid response from ERS link: " + responseMap)
		}

		log.info("responseMap : " + responseMap)
		String statusCode = actionHelperUtils.getMapValue(responseMap, STATUS_CODE, true, "").trim()
		log.info("statusCode : " + statusCode)

		Map<String, Object> actionDataMap = transaction.getActionResponseData().get(transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy())
		actionDataMap.put(STATUS_CODE, responseMap.get(STATUS_CODE))
		actionDataMap.put(MESSAGE, responseMap.get("message"))
		actionDataMap.put("resultCode", responseMap.get("resultCode"))
		actionDataMap.put("resultMessage", responseMap.get("resultMessage"))
		actionDataMap.put("type", responseMap.get("type"))

		if(RETRIABLE_STATUS_CODES.contains(statusCode)) {
			log.debug("Response from ERS link: {}", responseMap.get("message"))
			log.error("Retriable status code from ERS link: {}", statusCode)
			throw new RetriableException(responseMap.get(MESSAGE).toString(), LinkActionStatus.FAILED_AT_HANDLE_RESPONSE)
		}

		if(!SUCCESS_STATUS_CODES.contains(statusCode)) {
			log.error("Failed to perform Pin Change in ERS link: {}", responseMap.get("message"))
			throw new FailedAtExternalSystemException("Failed to perform Pin Change in ERS link: " + responseMap.get("message"))
		}
	}

	@Override
	protected void callback(HelperTransaction transaction) throws ActionProcessingException {
		log.debug("No callback defined for requestId: {} with inboundTxnId: {}",
				transaction.getInboundRequest().getId(), transaction.getInboundRequest().getInboundTxnId())
	}

	private String createJsonRequestString(String payload, SystemToken systemToken, HelperTransaction transaction) throws ActionProcessingException {
		Map<String, Object> jsonRequestMap = new HashMap<>()
		ObjectMapper mapper = new ObjectMapper();
		jsonRequestMap.put("transactionId", systemToken.getErsReference())
		Map<String, Object> payloadMap = commonUtils.convertObjectToMap(payload.toString())
		actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "msisdn", actionHelperUtils.getMapValue(payloadMap, "msisdn", true, ""))
		actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "pin", actionHelperUtils.getMapValue(payloadMap, "pin", true, ""))
		actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "newPin", actionHelperUtils.getMapValue(payloadMap, "newPin", true, ""))
		actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "confirmPin", actionHelperUtils.getMapValue(payloadMap, "confirmPin", true, ""))
		return commonUtils.parseJson(jsonRequestMap)
	}

	private HttpEntity<String> buildHttpEntity(String jsonRequest, String systemToken) {
		HttpHeaders headers = new HttpHeaders()
		headers.setContentType(MediaType.APPLICATION_JSON)
		headers.set("system-token", systemToken)
		headers.set("authorization", "U0VBTUxFU1M6M3F6ajY1a0w=")
		return new HttpEntity<>(jsonRequest, headers)
	}


	@Override
	protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException {
		log.info("Not implemented");
	}
}