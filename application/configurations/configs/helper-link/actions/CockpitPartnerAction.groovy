package se.seamless.idm.actions.impl

import com.seamless.common.transaction.SystemToken
import com.seamless.ers.interfaces.ersifcommon.dto.resellers.ResellerInfo
import groovy.transform.CompileStatic
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import se.seamless.idm.actions.AbstractAction
import se.seamless.idm.enums.LinkActionStatus
import se.seamless.idm.exceptions.ActionProcessingException
import se.seamless.idm.exceptions.FailedAtExternalSystemException
import se.seamless.idm.exceptions.PayloadParsingException
import se.seamless.idm.exceptions.RetriableException
import se.seamless.idm.model.HelperTransaction
import java.util.stream.Collectors
import java.util.concurrent.atomic.AtomicBoolean

@CompileStatic
class CockpitPartnerAction extends AbstractAction
{
	private final static Logger log = LoggerFactory.getLogger(CockpitPartnerAction.class);

	private final AtomicBoolean initialized = new AtomicBoolean(false)

	private String API_ENDPOINT
	private List<String> RETRIABLE_STATUS_CODES
	private int RETRY_DELAY_MS
	private String AUTH
	private int SUCCESS_RESULT_CODE
	private String MESSAGE
	private String STATUS_CODE

	@Override
	protected void loadActionData(HelperTransaction transaction) {
		if (!initialized.getAndSet(true)) {
			log.info("Initializing ActionData for ERSPartnerDeboadNotifierAction bean")
			API_ENDPOINT = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "API_ENDPOINT", "http://svc-idm-cockpit-link:15501/cockpitlink/v1/endpoint")
			RETRY_DELAY_MS = actionDataUtils.getActionDataInteger(transaction.getLinkActionInProgress(), "RETRY_DELAY_MS", transaction.getDefaultRetryDelayMs())
			AUTH = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "AUTH", "U0VBTUxFU1M6M3F6ajY1a0w=")
			RETRIABLE_STATUS_CODES = actionDataUtils.getActionDataList(transaction.getLinkActionInProgress(), "RETRIABLE_STATUS_CODES", Arrays.asList("500", "400"))
			SUCCESS_RESULT_CODE = actionDataUtils.getActionDataInteger(transaction.getLinkActionInProgress(), "SUCCESS_RESULT_CODE", 0)
			STATUS_CODE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "STATUS_CODE", "resultCode")
			MESSAGE = actionDataUtils.getActionDataString(transaction.getLinkActionInProgress(), "MESSAGE", "message")

			log.info("Action data loaded: API_ENDPOINT={}, RETRY_DELAY_MS={}, RETRIABLE_STATUS_CODES={}",
					API_ENDPOINT, RETRY_DELAY_MS, RETRIABLE_STATUS_CODES, STATUS_CODE, MESSAGE)
		}

		// Always set the transaction retry delay
		transaction.setDefaultRetryDelayMs(RETRY_DELAY_MS)
	}

	@Override
	protected void evaluatePreConditions(HelperTransaction transaction) throws ActionProcessingException
	{
		super.evaluatePreConditions(transaction);
		log.debug("No pre-conditions defined for requestId: {} with inboundTxnId: {}",
				transaction.getInboundRequest().getId(),
				transaction.getInboundRequest().getInboundTxnId());
	}

	@Override
	protected void validateRequest(HelperTransaction transaction) throws ActionProcessingException
	{
		log.info(
				"No validation defined for requestId: {} with inboundTxnId: {}",
				transaction.getInboundRequest().getId(),
				transaction.getInboundRequest().getInboundTxnId());
	}

	@Override
	protected void createRequest(HelperTransaction transaction) throws ActionProcessingException
	{
		log.info(
				"Started creation of request for requestId: {} with inboundTxnId: {}",
				transaction.getInboundRequest().getId(),
				transaction.getInboundRequest().getInboundTxnId());
		try
		{
			SystemToken systemToken = commonUtils.getSystemToken(transaction.getInboundRequest().getToken());
			Map<String, Object> jsonRequestMap = new HashMap<>();
			jsonRequestMap.put("transactionId", systemToken.getErsReference());
			actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "transactionId", systemToken.getErsReference());
			actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "infoType", "PARTNER");

			String operationType = transformToChangeType(transaction.getInboundRequest().getOperationType());
			actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "changeType", operationType);

			List<String> resourceIds = getResourceIds(transaction.getInboundRequest().getPayload());
			actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "resourceIds", resourceIds);
			actionHelperUtils.addParamsToJsonRequest(jsonRequestMap, "metaData", Collections.emptyMap());
			String jsonRequest = commonUtils.parseJson(jsonRequestMap);
			log.debug("Created JSON request: {}", jsonRequest);

			transaction.getLinkActionInProgress().setRequest(jsonRequest);
		}
		catch (Exception e)
		{
			log.error("Failed to create JSON request", e);
			throw new ActionProcessingException("Failed to create JSON request: " + e.getMessage());
		}
	}

	@Override
	protected void makeApiCall(HelperTransaction transaction) throws RetriableException
	{
		String jsonRequest = transaction.getLinkActionInProgress().getRequest();
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.setBasicAuth("U0VBTUxFU1M6M3F6ajY1a0w=");
		headers.set("system-token", transaction.getInboundRequest().getToken());
		HttpEntity<String> requestEntity = new HttpEntity<>(jsonRequest, headers);
		try
		{
			String response = restTemplate.postForObject(API_ENDPOINT, requestEntity, String.class);
			transaction.getLinkActionInProgress().setResponse(response);
		}
		catch (Exception e)
		{
			transaction.getLinkActionInProgress().setStatus(LinkActionStatus.FAILED_AT_API_CALL);
			log.error("Failed to make API call", e);
			throw new RetriableException("Failed to make API call: " + e.getMessage(), LinkActionStatus.FAILED_AT_API_CALL);
		}
	}

	@Override
	protected void handleResponse(HelperTransaction transaction)
			throws ActionProcessingException, FailedAtExternalSystemException, PayloadParsingException, RetriableException
	{
		//Throw RetryableException if we want to retry the API call
		if (Objects.isNull(transaction.getLinkActionInProgress().getResponse()))
		{
			log.error("NULL response from Cockpit");
			throw new FailedAtExternalSystemException("NULL response from Cockpit");
		}
		Map<String, Object> responseMap = commonUtils.convertObjectToMap(transaction.getLinkActionInProgress().getResponse());
		if (!responseMap.containsKey(STATUS_CODE))
		{
			log.error("Invalid response from Cockpit: {}", responseMap);
			throw new ActionProcessingException("Invalid response from Cockpit: " + responseMap);
		}

		Map<String, Object> actionDataMap = transaction.getActionResponseData().get(transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy());
		actionDataMap.put(STATUS_CODE, responseMap.get(STATUS_CODE));
		actionDataMap.put(MESSAGE, responseMap.get(MESSAGE));
		Integer statusCode = (Integer) responseMap.get(STATUS_CODE);

		if (RETRIABLE_STATUS_CODES.contains(statusCode))
		{
			log.debug("Response from Cockpit: {}", responseMap.get(MESSAGE));
			log.error("Retryable status code from Cockpit: {}", statusCode);
			throw new RetriableException(responseMap.get(MESSAGE).toString(), LinkActionStatus.FAILED_AT_HANDLE_RESPONSE);
		}

		if (statusCode != SUCCESS_RESULT_CODE)
		{
			log.error("Failed to update partner data in Cockpit: {}", responseMap.get(MESSAGE));
			throw new FailedAtExternalSystemException("Failed to update partner data in Cockpit: " + responseMap.get(MESSAGE));
		}
	}

	@Override
	protected void extractResponseData(HelperTransaction transaction) throws ActionProcessingException
	{
		String action = transaction.getLinkActionInProgress().getActionRule().getAction().getGroovy();
		Map<String, Object> actionDataMap = transaction.getActionResponseData().get(action);
		if (Objects.isNull(actionDataMap))
		{
			log.error("No action data map found for action: {}", action);
			throw new ActionProcessingException("No action data map found for action: " + action);
		}
		log.debug("Extracted action data map: {}", actionDataMap);
	}

	@Override
	protected void callback(HelperTransaction transaction) throws ActionProcessingException
	{
		log.debug(
				"No callback defined for requestId: {} with inboundTxnId: {}",
				transaction.getInboundRequest().getId(),
				transaction.getInboundRequest().getInboundTxnId());
	}

	private List<String> getResourceIds(String payload) throws ActionProcessingException, PayloadParsingException
	{
		if (Objects.isNull(payload))
			throw new ActionProcessingException("Payload can NOT be NULL");

		//Get the partnerCode/resellerId from JSON payload
		Map<String, Object> payloadMap = commonUtils.convertObjectToMap(payload.toString());
		Map<String, Object> resellerInfoMap = commonUtils.convertObjectToMap(payloadMap.get("reseller"));
		String resellerId = actionHelperUtils.getMapValue(resellerInfoMap, "resellerId", true, "")
		return Collections.singletonList(resellerId);
	}

	private static String transformToChangeType(String operationType) throws ActionProcessingException
	{
		switch (operationType)
		{
			case "addReseller":
			case "addResellerUsers":
			case "RESELLER_ONBOARD":
				return "CREATED";
			case "updateReseller":
			case "RESELLER_MODIFY":
			case "blockedReseller":
			case "RESELLER_SUSPEND":
			case "unBlockedReseller":
			case "updateResellerUsers":
				return "UPDATED";
			case "deActivateReseller":
				return "DELETED";
			default:
				throw new ActionProcessingException("Invalid operation type: " + operationType);
		}
	}
}
