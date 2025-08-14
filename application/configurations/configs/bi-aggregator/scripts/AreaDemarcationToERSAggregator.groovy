package com.seamless.customer.bi.aggregator.aggregate

import groovy.json.JsonSlurper
import groovy.util.logging.Slf4j
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.transaction.annotation.Transactional
import org.springframework.jdbc.core.BeanPropertyRowMapper
import java.sql.Timestamp
import wslite.rest.RESTClient
import java.nio.charset.StandardCharsets

/***
 * Created By   : Muhammad Ayaz
 * Email        : muhammad.ayaz@seamless.se
 * Created Date : 15/04/2025 (Copied and Modified)
 * Time         : 12:58
 * <p>
 * Copyright(c) 2025. Seamless Distribution Systems AB - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited. It is proprietary and confidential.
 * </p>
 ***/

@Slf4j
@Transactional
public class AreaDemarcationToERSAggregator extends AbstractAggregator {

    static final def TABLE = "demarcation_reseller"

    static final def PENDING = "PENDING"
    static final def PROCESSING = "PROCESSING"
    static final def FAILED = "FAILED"
    static final def PROCESSED = "PROCESSED"

    @Autowired
    @Qualifier("refill")
    protected JdbcTemplate jdbcTemplate;

    @Value('${AreaDemarcationToERSAggregator.retryCount:5}')
    int retryCount;

    @Value('${AreaDemarcationToERSAggregator.apiUrl:http://localhost/api/bss/v1/import/demarcation?importSubType=Area_demarcation}')
    private String apiUrl;

    @Value('${AreaDemarcationToERSAggregator.batchStatusApiUrl:http://10.33.96.98/api/bss/v1/batch}')
    private String batchStatusApiUrl;

    @Value('${AreaDemarcationToERSAggregator.loginApi.url:http://localhost/login-backend}')
    private String loginApiUrl;
    @Value('${AreaDemarcationToERSAggregator.loginApi.user:operator}')
    private String loginApiUser;
    @Value('${AreaDemarcationToERSAggregator.loginApi.password:Seamless@1234}')
    private String loginApiPassword;

    @Value('${AreaDemarcationToERSAggregator.idmLoginApi.url:http://10.33.96.98/login-backend}')
    private String idmLoginApiUrl;
    @Value('${AreaDemarcationToERSAggregator.idmLoginApi.user:operator}')
    private String idmLoginApiUser;
    @Value('${AreaDemarcationToERSAggregator.idmLoginApi.password:Seamless@1234}')
    private String idmLoginApiPassword;

    @Value('${AreaDemarcationToERSAggregator.notification.url:http://svc-notification-manager:8277/register}')
    private String notificationUrl;

    @Value('${AreaDemarcationToERSAggregator.email.senderId:bi-aggregator@seamless.se}')
    private String emailSenderId;

    @Value('${AreaDemarcationToERSAggregator.email.recipientId:alerts@example.com}')
    private String emailRecipientId;

    @Value('${AreaDemarcationToERSAggregator.email.notifications.enabled:true}')
    private boolean emailNotificationsEnabled;

    @Value('${AreaDemarcationToERSAggregator.sms.notifications.enabled:false}')
    private boolean smsNotificationsEnabled;

    @Value('${AreaDemarcationToERSAggregator.sms.senderMSISDN:SMS_SENDER}')
    private String smsSenderId;

    @Value('${AreaDemarcationToERSAggregator.sms.recipientMSISDN:}')
    private String smsRecipientId;

    @Value('${AreaDemarcationToERSAggregator.sms.success.message:Area demarcation batch %s processed. Records: %d.}')
    private String smsSuccessMessageTemplate;


    @Transactional
    @Scheduled(cron = '${AreaDemarcationToERSAggregator.cron:*/3 * * * * ?}')
    void aggregate() {
        log.info("-==-==-==-==-==-==-==-==-==-==-==-==- AreaDemarcationToERSAggregator Aggregator Started -==-==-==-==-==-==-==-==-==-==-==-==-");
        log.info("=====  Started On -> " + new Date());
        _aggregate();
        log.info("-==-==-==-==-==-==-==-==-==-==-==-==-  AreaDemarcationToERSAggregator Aggregator Ended  -==-==-==-==-==-==-==-==-==-==-==-==-");

    }


    public void _aggregate() {
        log.info("==== AreaDemarcationToERSAggregator -> _aggregate() -> Started");

        try {
            // Step 1: Fetch all PENDING records
            String selectQuery = "SELECT * FROM " + TABLE + " WHERE `status` = ?"
            List<DemarcationReseller> allPendingRecords = jdbcTemplate.query(selectQuery, new BeanPropertyRowMapper<>(DemarcationReseller.class), PENDING);
            log.info("==== AreaDemarcationToERSAggregator -> Fetched " + allPendingRecords.size() + " pending records from Table: " + TABLE);

            if (allPendingRecords.isEmpty()) {
                log.info("==== AreaDemarcationToERSAggregator -> No pending records found to process.");
                return;
            }

            // Step 2: Group records by batch_id
            Map<String, List<DemarcationReseller>> recordsByBatchId = allPendingRecords.groupBy { it.batchId }
            log.info("==== AreaDemarcationToERSAggregator -> Found records for ${recordsByBatchId.size()} different batch IDs: ${recordsByBatchId.keySet()}");

            // Step 3: Get API tokens once for all batch operations
            Map<String, String> apiTokens = fetchApiTokens(loginApiUrl, loginApiUser, loginApiPassword);
            if (!apiTokens) {
                log.error("==== AreaDemarcationToERSAggregator -> Failed to obtain API tokens. Skipping aggregation cycle.");
                return;
            }
            String authToken = apiTokens.get("authorization");

            // Step 4: Process each batch
            recordsByBatchId.each { batchId, records ->
                if (batchId == null || batchId.trim().isEmpty()) {
                    log.warn("==== AreaDemarcationToERSAggregator -> Skipping records with null/empty batch_id. Record count: ${records.size()}");
                    return; // Skip this batch
                }

                log.info("==== AreaDemarcationToERSAggregator -> Processing batch_id: $batchId with ${records.size()} records");

                // Step 4a: Check batch status via API
                Map<String, Object> batchStatusInfo = checkBatchStatus(batchId, authToken);
                if (!batchStatusInfo) {
                    log.warn("==== AreaDemarcationToERSAggregator -> Failed to get batch status for batch_id: $batchId. Skipping this batch.");
                    return; // Skip this batch
                }

                String batchStatus = batchStatusInfo.get("batchStatus") as String
                Integer processedCount = batchStatusInfo.get("processedCount") as Integer
                Integer totalCount = batchStatusInfo.get("totalCount") as Integer
                Integer failedCount = batchStatusInfo.get("failedCount") as Integer
                Integer successCount = batchStatusInfo.get("successCount") as Integer
                Integer pendingRecordsCount = records.size()

                log.info("==== AreaDemarcationToERSAggregator -> Batch $batchId status: $batchStatus, total: $totalCount, processed: $processedCount, success: $successCount, failed: $failedCount, pending records: $pendingRecordsCount");

                // Step 4b: Check if batch is processed and counts match
                if (batchStatus != "processed" && batchStatus != "partially-processed") {
                    log.info("==== AreaDemarcationToERSAggregator -> Batch $batchId is not in 'processed' or 'partially-processed' status. Current status: $batchStatus. Skipping.");
                    return; // Skip this batch
                }

                // For processed batches, all records should be processed successfully
                if (batchStatus == "processed") {
                    if (processedCount != pendingRecordsCount) {
                        log.warn("==== AreaDemarcationToERSAggregator -> Batch $batchId is marked as 'processed' but processed count ($processedCount) does not match pending records count ($pendingRecordsCount). Skipping.");
                        return; // Skip this batch
                    }

                    if (successCount != pendingRecordsCount) {
                        log.warn("==== AreaDemarcationToERSAggregator -> Batch $batchId is marked as 'processed' but success count ($successCount) does not match pending records count ($pendingRecordsCount). Skipping.");
                        return; // Skip this batch
                    }
                }

                // For partially-processed batches, we need to have some successful records
                if (batchStatus == "partially-processed") {
                    if (successCount == null || successCount <= 0) {
                        log.warn("==== AreaDemarcationToERSAggregator -> Batch $batchId is marked as 'partially-processed' but has no successful records (success count: $successCount). Skipping.");
                        return; // Skip this batch
                    }

                    if (processedCount != (successCount + (failedCount ?: 0))) {
                        log.warn("==== AreaDemarcationToERSAggregator -> Batch $batchId has inconsistent counts. Processed: $processedCount, Success: $successCount, Failed: $failedCount. Skipping.");
                        return; // Skip this batch
                    }

                    // For partially-processed, we expect some records may still be pending or failed
                    if (processedCount >= pendingRecordsCount) {
                        log.info("==== AreaDemarcationToERSAggregator -> Batch $batchId is marked as 'partially-processed' but all pending records appear to be processed ($processedCount >= $pendingRecordsCount). Processing as successful.");
                    } else {
                        log.info("==== AreaDemarcationToERSAggregator -> Batch $batchId is partially-processed with $successCount successful records out of $pendingRecordsCount pending records. Processing successful records only.");
                    }
                }

                // Step 4c: IDM batch is ready - now transfer to ERS
                log.info("==== AreaDemarcationToERSAggregator -> IDM Batch $batchId is ready. Proceeding to transfer data to ERS system.");
                processBatch(batchId, records, authToken, batchStatusInfo);
            }

        } catch (Exception e) {
            log.error("==== AreaDemarcationToERSAggregator -> _aggregate() -> Exception -> " + e.getMessage(), e);
        }
        log.info("==== AreaDemarcationToERSAggregator -> _aggregate() -> Ended");
    }

    /**
     * Checks the batch status via the batch status API.
     * @param batchId The batch ID to check status for.
     * @param authToken The authorization token for API calls (not used, will fetch IDM token).
     * @return Map containing batchStatus, processedCount, totalCount, failedCount, and successCount, or null if failed.
     */
    private Map<String, Object> checkBatchStatus(String batchId, String authToken) {
        log.info("==== AreaDemarcationToERSAggregator -> Checking batch status for batch_id: $batchId");

        if (!batchId) {
            log.error("==== AreaDemarcationToERSAggregator -> Batch status check aborted. Missing required parameter: batchId");
            return null
        }

        try {
            // Fetch IDM API tokens for batch status check
            Map<String, String> idmTokens = fetchApiTokens(idmLoginApiUrl, idmLoginApiUser, idmLoginApiPassword);
            if (!idmTokens) {
                log.error("==== AreaDemarcationToERSAggregator -> Failed to obtain IDM API tokens for batch status check.");
                return null
            }
            String idmAuthToken = idmTokens.get("authorization");

            String statusApiUrl = "${batchStatusApiUrl}/${batchId}/status"
            def client = new RESTClient(statusApiUrl)

            def response = client.get(
                    headers: [
                            'Authorization': idmAuthToken,
                            'Accept': 'application/json'
                    ]
            )

            log.info("==== AreaDemarcationToERSAggregator -> Batch status API response status: ${response.statusCode}")

            if (response.statusCode in 200..<300) {
                def parsedResponse = new JsonSlurper().parseText(response.text)

                if (parsedResponse?.resultCode == 0 && parsedResponse?.batchInfo) {
                    def batchInfo = parsedResponse.batchInfo[0] // Get first batch info
                    String batchStatus = batchInfo?.batchStatus
                    Integer processedCount = batchInfo?.records?.processed as Integer
                    Integer totalCount = batchInfo?.records?.total as Integer
                    Integer failedCount = batchInfo?.records?.failed as Integer
                    Integer successCount = batchInfo?.records?.success as Integer

                    log.info("==== AreaDemarcationToERSAggregator -> Batch $batchId status: $batchStatus, total: $totalCount, processed: $processedCount, success: $successCount, failed: $failedCount")

                    return [
                            batchStatus: batchStatus,
                            processedCount: processedCount,
                            totalCount: totalCount,
                            failedCount: failedCount,
                            successCount: successCount
                    ]
                } else {
                    log.error("==== AreaDemarcationToERSAggregator -> Invalid batch status response structure or resultCode: ${parsedResponse?.resultCode}")
                    return null
                }
            } else {
                log.error("==== AreaDemarcationToERSAggregator -> Batch status API call failed. Status: ${response.statusCode}, Body: ${response.text}")
                return null
            }
        } catch (Exception e) {
            log.error("==== AreaDemarcationToERSAggregator -> Exception during batch status API call: ${e.getMessage()}", e)
            return null
        }
    }

    /**
     * Processes a single batch: generates CSV file and calls the ERS import API.
     * @param batchId The IDM batch ID being processed.
     * @param records The list of DemarcationReseller records for this batch.
     * @param authToken The ERS authorization token for API calls.
     * @param batchStatusInfo The batch status information from the IDM API.
     */
    private void processBatch(String batchId, List<DemarcationReseller> records, String authToken, Map<String, Object> batchStatusInfo) {
        log.info("==== AreaDemarcationToERSAggregator -> Processing IDM batch $batchId with ${records.size()} records for ERS transfer");

        String batchStatus = batchStatusInfo.get("batchStatus") as String
        Integer successCount = batchStatusInfo.get("successCount") as Integer
        Integer failedCount = batchStatusInfo.get("failedCount") as Integer

        List<Long> processingIds = []
        String dynamicFilename = "IDM2ERS_area_demarcation_${batchId}.csv"

        try {
            // Mark records as PROCESSING
            processingIds = records*.id
            String updateToProcessingQuery = "UPDATE " + TABLE + " SET status = ?, last_process_runs_on = NOW() WHERE id IN (" + processingIds.join(',') + ")"
            int updatedRows = jdbcTemplate.update(updateToProcessingQuery, PROCESSING)
            log.info("==== AreaDemarcationToERSAggregator -> Marked " + updatedRows + " records as PROCESSING for IDM batch $batchId.");

            // Generate CSV Data
            StringBuilder csvData = new StringBuilder();
            // Add Header
            csvData.append("Msisdn,ResellerType,ToBeParent,ToBeOwner,ToBeRegionCode,ToBeClusterCode,ToBeTerritoryCode,ToBeThanaCode\n");
            // Add Data Rows
            records.each { reseller ->
                csvData.append("${reseller.getMsisdn() ?: ''},${reseller.getResellerType() ?: ''},${reseller.getToBeParent() ?: ''},${reseller.getToBeOwner() ?: ''},${reseller.getToBeRegion() ?: ''},${reseller.getToBeCluster() ?: ''},${reseller.getToBeTerritory() ?: ''},${reseller.getToBeThana() ?: ''}\n");
            }

            String csvContent = csvData.toString()
            log.info("==== AreaDemarcationToERSAggregator -> Generated CSV Data for IDM batch $batchId with ${records.size()} rows");


            // Call ERS API to import the data
            log.info("==== AreaDemarcationToERSAggregator -> Calling ERS API to import data from IDM batch $batchId");
            Map<String, Object> apiCallResult = callExternalApi(csvContent, authToken, dynamicFilename, batchId)

            List<Long> succeededIds = []
            List<Long> failedIds = []
            List<Long> retryIds = []

            if (apiCallResult.success) {
                // ERS API call successful
                succeededIds = processingIds // All succeeded
                if (!succeededIds.isEmpty()) {
                    // Prepare extra_params JSON with only ERS batch ID (like RegionDemarcationToERSAggregator)
                    String extraParamsJson = null
                    String ersBatchId = apiCallResult.ersBatchId as String
                    if (ersBatchId) {
                        extraParamsJson = "{\"ersBatchId\": \"${ersBatchId}\"}"
                        log.info("==== AreaDemarcationToERSAggregator -> Prepared extra_params with ERS batch ID: $ersBatchId")
                    } else {
                        log.warn("==== AreaDemarcationToERSAggregator -> No ERS batch ID received, extra_params will be null")
                    }

                    String updateToProcessedQuery = "UPDATE " + TABLE + " SET status = ?, processed_date = NOW(), file_name = ?, extra_params = ? WHERE id IN (" + succeededIds.join(',') + ")"
                    int updatedRowsProcessed = jdbcTemplate.update(updateToProcessedQuery, PROCESSED, dynamicFilename, extraParamsJson)
                    log.info("==== AreaDemarcationToERSAggregator -> Marked ${updatedRowsProcessed} records as PROCESSED. ERS batch ID: $ersBatchId");

                    // Send success email
                    String message = String.format("Successfully transferred area demarcation data from IDM to ERS. IDM Batch ID: %s, ERS Batch ID: %s, Filename: %s. Records processed: %d.", batchId, ersBatchId ?: "N/A", dynamicFilename, succeededIds.size());
                    sendEmail(message, csvContent, dynamicFilename);

                    // Send success SMS
                    String smsMessage = String.format("Area demarcation IDM batch %s transferred to ERS batch %s. Records: %d.", batchId, ersBatchId ?: "N/A", succeededIds.size());
                    sendSms(smsMessage);
                }

            } else {
                // ERS API call failed
                log.warn("==== AreaDemarcationToERSAggregator -> ERS API call failed for IDM batch $batchId. Determining retry/failure status for ${processingIds.size()} records.");
                // Separate records based on retry count
                records.each { reseller ->
                    int currentAttempts = (reseller.getAttempts() ?: 0) // Handle null attempts, default to 0
                    if (currentAttempts + 1 >= retryCount) {
                        failedIds.add(reseller.getId())
                    } else {
                        retryIds.add(reseller.getId())
                    }
                }

                // Update FAILED records (retry limit reached)
                if (!failedIds.isEmpty()) {
                    String updateToFailedQuery = "UPDATE " + TABLE + " SET status = ?, file_name = ? WHERE id IN (" + failedIds.join(',') + ")"
                    int updatedRowsFailed = jdbcTemplate.update(updateToFailedQuery, FAILED, dynamicFilename)
                    log.error("==== AreaDemarcationToERSAggregator -> Marked ${updatedRowsFailed} records as FAILED after reaching retry limit (${retryCount}) for IDM batch $batchId.");
                }

                // Update PENDING records (for retry) and increment attempts
                if (!retryIds.isEmpty()) {
                    String updateToRetryQuery = "UPDATE " + TABLE + " SET status = ?, attempts = attempts + 1 WHERE id IN (" + retryIds.join(',') + ")"
                    int updatedRowsPending = jdbcTemplate.update(updateToRetryQuery, PENDING)
                    log.warn("==== AreaDemarcationToERSAggregator -> Marked ${updatedRowsPending} records as PENDING for retry in IDM batch $batchId.");
                }
            }

        } catch (Exception e) {
            log.error("==== AreaDemarcationToERSAggregator -> Exception while processing IDM batch $batchId: ${e.getMessage()}", e);
            // Attempt to mark records as FAILED if an error occurred after marking them as PROCESSING
            if (!processingIds.isEmpty()) {
                try {
                    String updateToFailedQuery = "UPDATE " + TABLE + " SET status = ? WHERE id IN (" + processingIds.join(',') + ")"
                    int updatedRows = jdbcTemplate.update(updateToFailedQuery, FAILED)
                    log.error("==== AreaDemarcationToERSAggregator -> Exception occurred in IDM batch $batchId. Marked " + updatedRows + " records as FAILED.");
                } catch (Exception updateEx) {
                    log.error("==== AreaDemarcationToERSAggregator -> Failed to mark records as FAILED after exception in IDM batch $batchId: " + updateEx.getMessage(), updateEx);
                }
            }
        }
    }

    /**
     * Calls the ERS demarcation import API.
     * @param csvContent The CSV data as a string.
     * @param authToken The authorization token obtained from ERS login.
     * @param dynamicFilename The filename to use for the uploaded CSV data.
     * @param batchId The IDM batch ID to include in the description.
     * @return Map containing 'success' (boolean) and 'ersBatchId' (String) if successful.
     */
    private Map<String, Object> callExternalApi(String csvContent, String authToken, String dynamicFilename, String batchId) {
        log.info("==== AreaDemarcationToERSAggregator -> Calling ERS API at: $apiUrl using filename: $dynamicFilename for IDM batch: $batchId");

        Map<String, Object> result = [success: false, ersBatchId: null]

        if (!authToken) {
            log.error("==== AreaDemarcationToERSAggregator -> ERS API call aborted. Missing required parameters: authToken");
            return result
        }

        try {
            def client = new RESTClient(apiUrl)

            def csvBytes = csvContent.getBytes(StandardCharsets.UTF_8)
            def metaJson = """{
                "formatProperties":{"fileFormat":"CSV"},
                "scheduler":null,
                "failOnError":true,
                "fallbackOnError":false,
                "gatewayErrorsAutomaticRetry":true,
                "uploadedBy":"8801888003206",
                "description":"Area Demarcation From IDM System | IDM Batch Id: ${batchId}",
                "approvers":["admin","qa_approver"]
            }""".replaceAll(/\s+/, '')

            def response = client.post(
                    headers: [
                            'Authorization': authToken,
                            'Accept': '*/*'
                    ]
            ) {
                contentType = 'multipart/form-data'

                // Attach CSV file
                multipart('file', csvBytes, 'text/csv', dynamicFilename)

                // Attach JSON metadata
                multipart('metainformation', metaJson.getBytes(StandardCharsets.UTF_8), 'application/json', null)
            }

            log.info("==== AreaDemarcationToERSAggregator -> ERS API call response status: ${response.statusCode}")

            def parsedJsonResponse
            if (response.text != null && !response.text.isEmpty()) {
                try {
                    parsedJsonResponse = new JsonSlurper().parseText(response.text)
                } catch (Exception e) {
                    log.warn("==== AreaDemarcationToERSAggregator -> Failed to parse ERS response as JSON: ${e.getMessage()}. Response text was: ${response.text}")
                }
            } else {
                log.warn("==== AreaDemarcationToERSAggregator -> ERS response.text is null or empty, cannot parse for resultCode.")
            }

            if (response.statusCode in 200..<300 && parsedJsonResponse?.resultCode == 0) {
                // Extract ERS batch ID from response
                String ersBatchId = null
                if (parsedJsonResponse?.batchInfo && parsedJsonResponse.batchInfo.size() > 0) {
                    ersBatchId = parsedJsonResponse.batchInfo[0]?.batchId?.toString()
                    log.info("==== AreaDemarcationToERSAggregator -> Successfully extracted ERS batch ID: $ersBatchId for IDM batch: $batchId")
                } else {
                    log.warn("==== AreaDemarcationToERSAggregator -> No batchInfo found in ERS response for IDM batch: $batchId")
                }

                result.success = true
                result.ersBatchId = ersBatchId
                log.info("==== AreaDemarcationToERSAggregator -> ERS API call successful. resultCode: ${parsedJsonResponse?.resultCode}, ERS batch ID: $ersBatchId, IDM batch ID: $batchId")
                return result
            } else {
                String resultCodeValue = parsedJsonResponse?.resultCode != null ? parsedJsonResponse.resultCode.toString() : "not found or parsing failed"
                log.error("==== AreaDemarcationToERSAggregator -> ERS API call failed. Status: ${response.statusCode}, resultCode: ${resultCodeValue}. Response Body: ${response.text}")
                return result
            }
        } catch (Exception e) {
            log.error("==== AreaDemarcationToERSAggregator -> Exception during ERS API call: ${e.getMessage()}", e)
            return result
        }
    }

    private Map<String, String> fetchApiTokens(String loginUrl, String username, String password) {
        log.info("==== AreaDemarcationToERSAggregator -> Attempting to fetch API tokens from: $loginUrl");
        Map<String, String> tokens = [:]

        if (!password) {
            log.error("==== AreaDemarcationToERSAggregator -> Login API password is not configured. Cannot fetch tokens.");
            return tokens
        }

        try {
            RESTClient client = new RESTClient(loginUrl)

            log.debug("==== AreaDemarcationToERSAggregator -> Sending POST request to login API: $loginUrl")

            def response = client.post() {
                json channel: "web",
                        userId: username,
                        password: password,
                        sendOTP: false
            }

            if (response.statusCode >= 200 && response.statusCode < 300) {
                String authToken = response.headers['authorization']
                String ersRef = response.headers['ersReference']

                if (authToken && ersRef) {
                    log.info("==== AreaDemarcationToERSAggregator -> Successfully obtained API tokens from $loginUrl.");
                    tokens.put("authorization", authToken);
                    tokens.put("ersReference", ersRef);
                } else {
                    log.error("==== AreaDemarcationToERSAggregator -> Login successful, but 'authorization' or 'ersReference' header missing in response headers: ${response.headers.keySet()}");
                }
            } else {
                log.error("==== AreaDemarcationToERSAggregator -> Login API call failed. Status: ${response.statusCode}, Body: ${response.text}");
            }

        } catch (Exception e) {
            log.error("==== AreaDemarcationToERSAggregator -> Unexpected exception during login API call: ${e.getMessage()}", e);
        }

        return tokens;
    }

    private void sendEmail(String messageBody, String csvAttachmentContent, String attachmentFilename) {
        if (!emailNotificationsEnabled) {
            log.info("==== AreaDemarcationToERSAggregator -> Email notifications are disabled by configuration. Skipping email.")
            return
        }
        if (!notificationUrl || !emailSenderId || !emailRecipientId) {
            log.warn("==== AreaDemarcationToERSAggregator -> Email notification properties (URL, sender, recipient) not fully configured. Skipping email.")
            return
        }
        if (!messageBody) {
            log.warn("==== AreaDemarcationToERSAggregator -> Email subject or message body is empty. Skipping email.")
            return
        }

        log.info("==== AreaDemarcationToERSAggregator -> Attempting to send email notification.");
        def effectiveUrl = notificationUrl.endsWith("/register") ? notificationUrl : notificationUrl + "/register";
        RESTClient client = new RESTClient(effectiveUrl)

        Map<String, Object> emailFields = [
                notificationType: "EMAIL_ATTACHMENT",
                senderId        : emailSenderId,
                recipientId     : emailRecipientId,
                message         : messageBody,
                referenceEventId: "1234", // Can be made more specific if needed
                EMAILPROPS      : [
                        SUBJECT_IDENTIFIER: "IDM2ERS_AREA_DEMARCATION", // New and updated
                        SUBJECT       : "Area Demarcation - Batch Processed Successfully", // Hardcoded
                        CLASSIFIERNAME: "MAIL_ATTACHMENT"
                ]
        ]

        if (csvAttachmentContent && !csvAttachmentContent.isEmpty() && attachmentFilename) {
            log.info("==== AreaDemarcationToERSAggregator -> Preparing CSV attachment: $attachmentFilename")
            List<String> rawCsvLines = csvAttachmentContent.split('\\r?\\n').toList()
            List<String> nonEmptyCsvLines = rawCsvLines.findAll { line -> line != null && !line.trim().isEmpty() }


            if (!nonEmptyCsvLines.isEmpty()) {
                emailFields.excelData = nonEmptyCsvLines
                Map emailProps = emailFields.EMAILPROPS as Map
                emailProps.ATTACHMENTFORMAT = "EXCEL"
                String baseName = attachmentFilename.lastIndexOf('.') > 0 ? attachmentFilename.substring(0, attachmentFilename.lastIndexOf('.')) : attachmentFilename
                emailProps.ATTACHMENTNAME = baseName + ".xls"
                log.info("==== AreaDemarcationToERSAggregator -> Attachment ${emailProps.ATTACHMENTNAME} prepared with ${nonEmptyCsvLines.size()} lines.")
            } else {
                log.warn("==== AreaDemarcationToERSAggregator -> CSV content for attachment $attachmentFilename is effectively empty after filtering. Skipping attachment.")
            }
        } else if (csvAttachmentContent && attachmentFilename) {
            log.warn("==== AreaDemarcationToERSAggregator -> CSV content for attachment $attachmentFilename is an empty string. Skipping attachment.")
        }


        try {
            def response = client.post() {
                json eventTag: "ADHOC_ALERT", // Updated event tag
                        fields  : emailFields
            }
            log.info("==== AreaDemarcationToERSAggregator -> Email notification sent. Response status: ${response.statusCode}, data: ${response.data}")
        } catch (Exception e) {
            log.error("==== AreaDemarcationToERSAggregator -> Error sending email notification: ${e.getMessage()}", e)
        }
    }

    private void sendSms(String messageBody) {
        if (!smsNotificationsEnabled) {
            log.info("==== AreaDemarcationToERSAggregator -> SMS notifications are disabled by configuration. Skipping SMS.")
            return
        }
        if (!notificationUrl || !smsSenderId || !smsRecipientId) {
            log.warn("==== AreaDemarcationToERSAggregator -> SMS notification properties (URL, senderId, recipientId) not fully configured. Skipping SMS.")
            return
        }
        if (!messageBody) {
            log.warn("==== AreaDemarcationToERSAggregator -> SMS message body is empty. Skipping SMS.")
            return
        }

        log.info("==== AreaDemarcationToERSAggregator -> Attempting to send SMS.");
        def effectiveUrl = notificationUrl.endsWith("/register") ? notificationUrl : notificationUrl + "/register";
        RESTClient client = new RESTClient(effectiveUrl)

        try {
            def response = client.post() {
                json eventTag: "ADHOC_ALERT",
                        fields  : [
                                notificationType: "SMS",
                                senderid        : smsSenderId,
                                recipientId     : smsRecipientId,
                                message         : "This SMS is automated based just to inform you that the area demarcation on ERS system is initialized",
                                referenceEventId: "ad_sms_agg_${System.currentTimeMillis()}" // Updated reference prefix
                        ]
            }
            log.info("==== AreaDemarcationToERSAggregator -> SMS notification sent. Response status: ${response.statusCode}, data: ${response.data}")
        } catch (Exception e) {
            log.error("==== AreaDemarcationToERSAggregator -> Error sending SMS notification: ${e.getMessage()}", e)
        }
    }
}


class DemarcationReseller {
    private Long id;
    private String jobId;
    private String batchId;
    private String msisdn;
    private String resellerType;
    private String toBeParent;
    private String toBeOwner;
    private String toBeRegion;
    private String toBeCluster;
    private String toBeTerritory;
    private String toBeThana;
    private String status;
    private Timestamp createdOn;
    private Timestamp lastProcessRunsOn;
    private Timestamp processedDate;
    private String fileName;
    private Integer attempts;
    private String extraParams;

    // Getters and Setters
    Long getId() { return id }
    void setId(Long id) { this.id = id }

    String getJobId() { return jobId }
    void setJobId(String jobId) { this.jobId = jobId }

    String getBatchId() { return batchId }
    void setBatchId(String batchId) { this.batchId = batchId }

    String getMsisdn() { return msisdn }
    void setMsisdn(String msisdn) { this.msisdn = msisdn }

    String getResellerType() { return resellerType }
    void setResellerType(String resellerType) { this.resellerType = resellerType }

    String getToBeParent() { return toBeParent }
    void setToBeParent(String toBeParent) { this.toBeParent = toBeParent }

    String getToBeOwner() { return toBeOwner }
    void setToBeOwner(String toBeOwner) { this.toBeOwner = toBeOwner }

    String getToBeRegion() { return toBeRegion }
    void setToBeRegion(String toBeRegion) { this.toBeRegion = toBeRegion }

    String getToBeCluster() { return toBeCluster }
    void setToBeCluster(String toBeCluster) { this.toBeCluster = toBeCluster }

    String getToBeTerritory() { return toBeTerritory }
    void setToBeTerritory(String toBeTerritory) { this.toBeTerritory = toBeTerritory }

    String getToBeThana() { return toBeThana }
    void setToBeThana(String toBeThana) { this.toBeThana = toBeThana }

    String getStatus() { return status }
    void setStatus(String status) { this.status = status }

    Timestamp getCreatedOn() { return createdOn }
    void setCreatedOn(Timestamp createdOn) { this.createdOn = createdOn }

    Timestamp getLastProcessRunsOn() { return lastProcessRunsOn }
    void setLastProcessRunsOn(Timestamp lastProcessRunsOn) { this.lastProcessRunsOn = lastProcessRunsOn }

    Timestamp getProcessedDate() { return processedDate }
    void setProcessedDate(Timestamp processedDate) { this.processedDate = processedDate }

    String getFileName() { return fileName }
    void setFileName(String fileName) { this.fileName = fileName }

    Integer getAttempts() { return attempts }
    void setAttempts(Integer attempts) { this.attempts = attempts }

    String getExtraParams() { return extraParams }
    void setExtraParams(String extraParams) { this.extraParams = extraParams }
}