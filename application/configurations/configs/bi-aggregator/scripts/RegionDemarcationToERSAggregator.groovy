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
 * Created By   : Hassan Sohail
 * Email        : hassan.sohail@seamless.se
 * Created Date : 15/04/2025
 * Time         : 12:58
 * <p>
 * Copyright(c) 2025. Seamless Distribution Systems AB - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited. It is proprietary and confidential.
 * </p>
 ***/

@Slf4j
@Transactional
public class RegionDemarcationToERSAggregator extends AbstractAggregator {

    static final def TABLE = "demarcation_region"

    static final def PENDING = "PENDING"
    static final def PROCESSING = "PROCESSING"
    static final def FAILED = "FAILED"
    static final def PROCESSED = "PROCESSED"

    @Autowired
    @Qualifier("refill")
    protected JdbcTemplate jdbcTemplate;

    @Value('${RegionDemarcationToERSAggregator.retryCount:5}')
    int retryCount;

    @Value('${RegionDemarcationToERSAggregator.apiUrl:http://localhost/api/bss/v1/import/demarcation?importSubType=Region_demarcation}')
    private String apiUrl;

    @Value('${RegionDemarcationToERSAggregator.batchStatusApiUrl:http://localhost/api/bss/v1/batch}')
    private String batchStatusApiUrl;

    @Value('${RegionDemarcationToERSAggregator.loginApi.url:http://localhost/login-backend}')
    private String loginApiUrl;
    @Value('${RegionDemarcationToERSAggregator.loginApi.user:operator}')
    private String loginApiUser;
    @Value('${RegionDemarcationToERSAggregator.loginApi.password:Seamless@1234}')
    private String loginApiPassword;

    @Value('${RegionDemarcationToERSAggregator.idmLoginApi.url:http://localhost/login-backend}')
    private String idmLoginApiUrl;
    @Value('${RegionDemarcationToERSAggregator.idmLoginApi.user:operator}')
    private String idmLoginApiUser;
    @Value('${RegionDemarcationToERSAggregator.idmLoginApi.password:2023}')
    private String idmLoginApiPassword;

    @Value('${RegionDemarcationToERSAggregator.notification.url:http://svc-notification-manager:8277/notification}')
    private String notificationUrl;

    @Value('${RegionDemarcationToERSAggregator.email.senderId:bi-aggregator@seamless.se}')
    private String emailSenderId;

    @Value('${RegionDemarcationToERSAggregator.email.recipientId:alerts@example.com}')
    private String emailRecipientId;

    @Value('${RegionDemarcationToERSAggregator.email.notifications.enabled:true}')
    private boolean emailNotificationsEnabled;

    @Value('${RegionDemarcationToERSAggregator.sms.notifications.enabled:false}')
    private boolean smsNotificationsEnabled;

    @Value('${RegionDemarcationToERSAggregator.sms.senderMSISDN:SMS_SENDER}')
    private String smsSenderId;

    @Value('${RegionDemarcationToERSAggregator.sms.recipientMSISDN:}')
    private String smsRecipientId;

    @Transactional
    @Scheduled(cron = '${RegionDemarcationToERSAggregator.cron:*/3 * * * * ?}')
    void aggregate() {
        log.info("-==-==-==-==-==-==-==-==-==-==-==-==- RegionDemarcationToERSAggregator Aggregator Started -==-==-==-==-==-==-==-==-==-==-==-==-");
        log.info("=====  Started On -> " + new Date());
        _aggregate();
        log.info("-==-==-==-==-==-==-==-==-==-==-==-==-  RegionDemarcationToERSAggregator Aggregator Ended  -==-==-==-==-==-==-==-==-==-==-==-==-");
    }

    public void _aggregate() {
        log.info("==== RegionDemarcationToERSAggregator -> _aggregate() -> Started");

        try {
            // Step 1: Fetch all PENDING records
            String selectQuery = "SELECT * FROM " + TABLE + " WHERE `status` = ?"
            List<DemarcationRegion> allPendingRecords = jdbcTemplate.query(selectQuery, new BeanPropertyRowMapper<>(DemarcationRegion.class), PENDING);
            log.info("==== RegionDemarcationToERSAggregator -> Fetched " + allPendingRecords.size() + " pending records from Table: " + TABLE);

            if (allPendingRecords.isEmpty()) {
                log.info("==== RegionDemarcationToERSAggregator -> No pending records found to process.");
                return;
            }

            // Step 2: Group records by batch_id
            Map<String, List<DemarcationRegion>> recordsByBatchId = allPendingRecords.groupBy { it.batchId }
            log.info("==== RegionDemarcationToERSAggregator -> Found records for ${recordsByBatchId.size()} different batch IDs: ${recordsByBatchId.keySet()}");

            // Step 3: Get API tokens once for all batch operations
            Map<String, String> apiTokens = fetchApiTokens(loginApiUrl, loginApiUser, loginApiPassword);
            if (!apiTokens) {
                log.error("==== RegionDemarcationToERSAggregator -> Failed to obtain ERS API tokens. Skipping aggregation cycle.");
                return;
            }
            String authToken = apiTokens.get("authorization");

            // Step 4: Process each batch
            recordsByBatchId.each { batchId, records ->
                if (batchId == null || batchId.trim().isEmpty()) {
                    log.warn("==== RegionDemarcationToERSAggregator -> Skipping records with null/empty batch_id. Record count: ${records.size()}");
                    return; // Skip this batch
                }

                log.info("==== RegionDemarcationToERSAggregator -> Processing batch_id: $batchId with ${records.size()} records");

                // Step 4a: Check IDM batch status via API
                Map<String, Object> batchStatusInfo = checkBatchStatus(batchId, authToken);
                if (!batchStatusInfo) {
                    log.warn("==== RegionDemarcationToERSAggregator -> Failed to get IDM batch status for batch_id: $batchId. Skipping this batch.");
                    return; // Skip this batch
                }

                String batchStatus = batchStatusInfo.get("batchStatus") as String
                Integer processedCount = batchStatusInfo.get("processedCount") as Integer
                Integer totalCount = batchStatusInfo.get("totalCount") as Integer
                Integer failedCount = batchStatusInfo.get("failedCount") as Integer
                Integer successCount = batchStatusInfo.get("successCount") as Integer
                Integer pendingRecordsCount = records.size()

                log.info("==== RegionDemarcationToERSAggregator -> IDM Batch $batchId status: $batchStatus, total: $totalCount, processed: $processedCount, success: $successCount, failed: $failedCount, pending records: $pendingRecordsCount");

                // Step 4b: Check if IDM batch is processed and ready for ERS transfer
                if (batchStatus != "processed" && batchStatus != "partially-processed") {
                    log.info("==== RegionDemarcationToERSAggregator -> IDM Batch $batchId is not ready for ERS transfer. Current status: $batchStatus. Skipping.");
                    return; // Skip this batch
                }

                // For processed batches, verify all records are successful
                if (batchStatus == "processed") {
                    if (processedCount != pendingRecordsCount) {
                        log.warn("==== RegionDemarcationToERSAggregator -> IDM Batch $batchId processed count ($processedCount) does not match pending records count ($pendingRecordsCount). Skipping.");
                        return; // Skip this batch
                    }

                    if (successCount != pendingRecordsCount) {
                        log.warn("==== RegionDemarcationToERSAggregator -> IDM Batch $batchId success count ($successCount) does not match pending records count ($pendingRecordsCount). Skipping.");
                        return; // Skip this batch
                    }
                }

                // For partially-processed batches, ensure we have some successful records
                if (batchStatus == "partially-processed") {
                    if (successCount == null || successCount <= 0) {
                        log.warn("==== RegionDemarcationToERSAggregator -> IDM Batch $batchId is partially-processed but has no successful records (success count: $successCount). Skipping.");
                        return; // Skip this batch
                    }
                    log.info("==== RegionDemarcationToERSAggregator -> IDM Batch $batchId is partially-processed with $successCount successful records. Proceeding with ERS transfer.");
                }

                // Step 4c: IDM batch is ready - now transfer to ERS
                log.info("==== RegionDemarcationToERSAggregator -> IDM Batch $batchId is ready. Proceeding to transfer data to ERS system.");
                processBatch(batchId, records, authToken);
            }

        } catch (Exception e) {
            log.error("==== RegionDemarcationToERSAggregator -> _aggregate() -> Exception -> " + e.getMessage(), e);
        }
        log.info("==== RegionDemarcationToERSAggregator -> _aggregate() -> Ended");
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
        log.info("==== RegionDemarcationToERSAggregator -> Calling ERS API at: $apiUrl using filename: $dynamicFilename for IDM batch: $batchId");

        Map<String, Object> result = [success: false, ersBatchId: null]

        if (!authToken) {
            log.error("==== RegionDemarcationToERSAggregator -> ERS API call aborted. Missing required parameters: authToken");
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
                "description":"Region Demarcation From IDM System | IDM Batch Id: ${batchId}",
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

            log.info("==== RegionDemarcationToERSAggregator -> ERS API call response status: ${response.statusCode}")

            def parsedJsonResponse
            if (response.text != null && !response.text.isEmpty()) {
                try {
                    parsedJsonResponse = new JsonSlurper().parseText(response.text)
                } catch (Exception e) {
                    log.warn("==== RegionDemarcationToERSAggregator -> Failed to parse ERS response as JSON: ${e.getMessage()}. Response text was: ${response.text}")
                }
            } else {
                log.warn("==== RegionDemarcationToERSAggregator -> ERS response.text is null or empty, cannot parse for resultCode.")
            }

            if (response.statusCode in 200..<300 && parsedJsonResponse?.resultCode == 0) {
                // Extract ERS batch ID from response
                String ersBatchId = null
                if (parsedJsonResponse?.batchInfo && parsedJsonResponse.batchInfo.size() > 0) {
                    ersBatchId = parsedJsonResponse.batchInfo[0]?.batchId?.toString()
                    log.info("==== RegionDemarcationToERSAggregator -> Successfully extracted ERS batch ID: $ersBatchId for IDM batch: $batchId")
                } else {
                    log.warn("==== RegionDemarcationToERSAggregator -> No batchInfo found in ERS response for IDM batch: $batchId")
                }

                result.success = true
                result.ersBatchId = ersBatchId
                log.info("==== RegionDemarcationToERSAggregator -> ERS API call successful. resultCode: ${parsedJsonResponse?.resultCode}, ERS batch ID: $ersBatchId, IDM batch ID: $batchId")
                return result
            } else {
                String resultCodeValue = parsedJsonResponse?.resultCode != null ? parsedJsonResponse.resultCode.toString() : "not found or parsing failed"
                log.error("==== RegionDemarcationToERSAggregator -> ERS API call failed. Status: ${response.statusCode}, resultCode: ${resultCodeValue}. Response Body: ${response.text}")
                return result
            }
        } catch (Exception e) {
            log.error("==== RegionDemarcationToERSAggregator -> Exception during ERS API call: ${e.getMessage()}", e)
            return result
        }
    }

    private Map<String, String> fetchApiTokens(String loginUrl, String username, String password) {
        log.info("==== RegionDemarcationToERSAggregator -> Attempting to fetch API tokens from: $loginUrl");
        Map<String, String> tokens = [:]

        if (!password) {
            log.error("==== RegionDemarcationToERSAggregator -> Login API password is not configured. Cannot fetch tokens.");
            return tokens
        }

        try {
            RESTClient client = new RESTClient(loginUrl)

            log.debug("==== RegionDemarcationToERSAggregator -> Sending POST request to login API: $loginUrl")

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
                    log.info("==== RegionDemarcationToERSAggregator -> Successfully obtained API tokens from $loginUrl.");
                    tokens.put("authorization", authToken);
                    tokens.put("ersReference", ersRef);
                } else {
                    log.error("==== RegionDemarcationToERSAggregator -> Login successful, but 'authorization' or 'ersReference' header missing in response headers: ${response.headers.keySet()}");
                }
            } else {
                log.error("==== RegionDemarcationToERSAggregator -> Login API call failed. Status: ${response.statusCode}, Body: ${response.text}");
            }

        } catch (Exception e) {
            log.error("==== RegionDemarcationToERSAggregator -> Unexpected exception during login API call: ${e.getMessage()}", e);
        }

        return tokens;
    }

    private void sendEmail(String messageBody, String csvAttachmentContent, String attachmentFilename) {
        if (!emailNotificationsEnabled) {
            log.info("==== RegionDemarcationToERSAggregator -> Email notifications are disabled by configuration. Skipping email.")
            return
        }
        if (!notificationUrl || !emailSenderId || !emailRecipientId) {
            log.warn("==== RegionDemarcationToERSAggregator -> Email notification properties (URL, sender, recipient) not fully configured. Skipping email.")
            return
        }
        if (!messageBody) {
            log.warn("==== RegionDemarcationToERSAggregator -> Email subject or message body is empty. Skipping email.")
            return
        }

        log.info("==== RegionDemarcationToERSAggregator -> Attempting to send email notification.");
        def effectiveUrl = notificationUrl.endsWith("/register") ? notificationUrl : notificationUrl + "/register";
        RESTClient client = new RESTClient(effectiveUrl)

        Map<String, Object> emailFields = [
                notificationType: "EMAIL_ATTACHMENT",
                senderId        : emailSenderId,
                recipientId     : emailRecipientId,
                message         : messageBody,
                referenceEventId: "1234",
                EMAILPROPS      : [
                        SUBJECT_IDENTIFIER       : "IDM2ERS_REGION_DEMARCATION",
                        SUBJECT       : "Region Demarcation - Batch Processed Successfully",
                        CLASSIFIERNAME: "MAIL_ATTACHMENT"
                ]
        ]

        if (csvAttachmentContent && !csvAttachmentContent.isEmpty() && attachmentFilename) {
            log.info("==== RegionDemarcationToERSAggregator -> Preparing CSV attachment: $attachmentFilename")
            List<String> rawCsvLines = csvAttachmentContent.split('\\r?\\n').toList()
            List<String> nonEmptyCsvLines = rawCsvLines.findAll { line -> line != null && !line.trim().isEmpty() }

            if (!nonEmptyCsvLines.isEmpty()) {
                emailFields.excelData = nonEmptyCsvLines
                Map emailProps = emailFields.EMAILPROPS as Map
                emailProps.ATTACHMENTFORMAT = "EXCEL"
                String baseName = attachmentFilename.lastIndexOf('.') > 0 ? attachmentFilename.substring(0, attachmentFilename.lastIndexOf('.')) : attachmentFilename
                emailProps.ATTACHMENTNAME = baseName + ".xls"
                log.info("==== RegionDemarcationToERSAggregator -> Attachment ${emailProps.ATTACHMENTNAME} prepared with ${nonEmptyCsvLines.size()} lines.")
            } else {
                log.warn("==== RegionDemarcationToERSAggregator -> CSV content for attachment $attachmentFilename is effectively empty after filtering. Skipping attachment.")
            }
        } else if (csvAttachmentContent && attachmentFilename) {
            log.warn("==== RegionDemarcationToERSAggregator -> CSV content for attachment $attachmentFilename is an empty string. Skipping attachment.")
        }

        try {
            def response = client.post() {
                json eventTag: "ADHOC_ALERT",
                        fields  : emailFields
            }
            log.info("==== RegionDemarcationToERSAggregator -> Email notification sent. Response status: ${response.statusCode}, data: ${response.data}")
        } catch (Exception e) {
            log.error("==== RegionDemarcationToERSAggregator -> Error sending email notification: ${e.getMessage()}", e)
        }
    }

    private void sendSms(String messageBody) {
        if (!smsNotificationsEnabled) {
            log.info("==== RegionDemarcationToERSAggregator -> SMS notifications are disabled by configuration. Skipping SMS.")
            return
        }
        if (!notificationUrl || !smsSenderId || !smsRecipientId) {
            log.warn("==== RegionDemarcationToERSAggregator -> SMS notification properties (URL, senderId, recipientId) not fully configured. Skipping SMS.")
            return
        }
        if (!messageBody) {
            log.warn("==== RegionDemarcationToERSAggregator -> SMS message body is empty. Skipping SMS.")
            return
        }

        log.info("==== RegionDemarcationToERSAggregator -> Attempting to send SMS.");
        def effectiveUrl = notificationUrl.endsWith("/register") ? notificationUrl : notificationUrl + "/register";
        RESTClient client = new RESTClient(effectiveUrl)

        try {
            def response = client.post() {
                json eventTag: "ADHOC_ALERT",
                        fields  : [
                                notificationType: "SMS",
                                senderid        : smsSenderId,
                                recipientId     : smsRecipientId,
                                message         : "This SMS is automated based just to inform you that the demarcation on ERS system is initialized",
                                referenceEventId: "rd_sms_agg_${System.currentTimeMillis()}"
                        ]
            }
            log.info("==== RegionDemarcationToERSAggregator -> SMS notification sent. Response status: ${response.statusCode}, data: ${response.data}")
        } catch (Exception e) {
            log.error("==== RegionDemarcationToERSAggregator -> Error sending SMS notification: ${e.getMessage()}", e)
        }
    }

    /**
     * Checks the IDM batch status via the batch status API.
     * @param batchId The IDM batch ID to check status for.
     * @param authToken The ERS authorization token (not used for IDM calls).
     * @return Map containing batchStatus, processedCount, totalCount, failedCount, and successCount, or null if failed.
     */
    private Map<String, Object> checkBatchStatus(String batchId, String authToken) {
        log.info("==== RegionDemarcationToERSAggregator -> Checking IDM batch status for batch_id: $batchId");

        if (!batchId) {
            log.error("==== RegionDemarcationToERSAggregator -> IDM batch status check aborted. Missing required parameter: batchId");
            return null
        }

        try {
            // Fetch IDM API tokens for batch status check
            Map<String, String> idmTokens = fetchApiTokens(idmLoginApiUrl, idmLoginApiUser, idmLoginApiPassword);
            if (!idmTokens) {
                log.error("==== RegionDemarcationToERSAggregator -> Failed to obtain IDM API tokens for batch status check.");
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

            log.info("==== RegionDemarcationToERSAggregator -> IDM batch status API response status: ${response.statusCode}")

            if (response.statusCode in 200..<300) {
                def parsedResponse = new JsonSlurper().parseText(response.text)

                if (parsedResponse?.resultCode == 0 && parsedResponse?.batchInfo) {
                    def batchInfo = parsedResponse.batchInfo[0] // Get first batch info
                    String batchStatus = batchInfo?.batchStatus
                    Integer processedCount = batchInfo?.records?.processed as Integer
                    Integer totalCount = batchInfo?.records?.total as Integer
                    Integer failedCount = batchInfo?.records?.failed as Integer
                    Integer successCount = batchInfo?.records?.success as Integer

                    log.info("==== RegionDemarcationToERSAggregator -> IDM Batch $batchId status: $batchStatus, total: $totalCount, processed: $processedCount, success: $successCount, failed: $failedCount")

                    return [
                        batchStatus: batchStatus,
                        processedCount: processedCount,
                        totalCount: totalCount,
                        failedCount: failedCount,
                        successCount: successCount
                    ]
                } else {
                    log.error("==== RegionDemarcationToERSAggregator -> Invalid IDM batch status response structure or resultCode: ${parsedResponse?.resultCode}")
                    return null
                }
            } else {
                log.error("==== RegionDemarcationToERSAggregator -> IDM batch status API call failed. Status: ${response.statusCode}, Body: ${response.text}")
                return null
            }
        } catch (Exception e) {
            log.error("==== RegionDemarcationToERSAggregator -> Exception during IDM batch status API call: ${e.getMessage()}", e)
            return null
        }
    }

    /**
     * Processes a single batch: generates CSV file and calls the ERS import API.
     * @param batchId The IDM batch ID being processed.
     * @param records The list of DemarcationRegion records for this batch.
     * @param authToken The ERS authorization token for API calls.
     */
    private void processBatch(String batchId, List<DemarcationRegion> records, String authToken) {
        log.info("==== RegionDemarcationToERSAggregator -> Processing IDM batch $batchId with ${records.size()} records for ERS transfer");

        List<Long> processingIds = []
        String dynamicFilename = "IDM2ERS_region_demarcation_${batchId}.csv"

        try {
            // Mark records as PROCESSING
            processingIds = records*.id
            String updateToProcessingQuery = "UPDATE " + TABLE + " SET status = ?, last_process_runs_on = NOW() WHERE id IN (" + processingIds.join(',') + ")"
            int updatedRows = jdbcTemplate.update(updateToProcessingQuery, PROCESSING)
            log.info("==== RegionDemarcationToERSAggregator -> Marked " + updatedRows + " records as PROCESSING for IDM batch $batchId.");

            // Generate CSV Data
            StringBuilder csvData = new StringBuilder();
            // Add Header
            csvData.append("Region,Cluster,Territory,Thana\n");
            // Add Data Rows
            records.each { region ->
                csvData.append("${region.getRegion() ?: ''},${region.getCluster() ?: ''},${region.getTerritory() ?: ''},${region.getThana() ?: ''}\n");
            }

            String csvContent = csvData.toString()
            log.info("==== RegionDemarcationToERSAggregator -> Generated CSV Data for IDM batch $batchId with ${records.size()} rows");

            // Call ERS API to import the data
            log.info("==== RegionDemarcationToERSAggregator -> Calling ERS API to import data from IDM batch $batchId");
            Map<String, Object> apiCallResult = callExternalApi(csvContent, authToken, dynamicFilename, batchId)

            List<Long> succeededIds = []
            List<Long> failedIds = []
            List<Long> retryIds = []

            if (apiCallResult.success) {
                // ERS API call successful
                succeededIds = processingIds // All succeeded
                if (!succeededIds.isEmpty()) {
                    // Prepare extra_params JSON with only ERS batch ID (like original aggregator)
                    String extraParamsJson = null
                    String ersBatchId = apiCallResult.ersBatchId as String
                    if (ersBatchId) {
                        extraParamsJson = "{\"ersBatchId\": \"${ersBatchId}\"}"
                        log.info("==== RegionDemarcationToERSAggregator -> Prepared extra_params with ERS batch ID: $ersBatchId")
                    } else {
                        log.warn("==== RegionDemarcationToERSAggregator -> No ERS batch ID received, extra_params will be null")
                    }

                    String updateToProcessedQuery = "UPDATE " + TABLE + " SET status = ?, processed_date = NOW(), file_name = ?, extra_params = ? WHERE id IN (" + succeededIds.join(',') + ")"
                    int updatedRowsProcessed = jdbcTemplate.update(updateToProcessedQuery, PROCESSED, dynamicFilename, extraParamsJson)
                    log.info("==== RegionDemarcationToERSAggregator -> Marked ${updatedRowsProcessed} records as PROCESSED. ERS batch ID: $ersBatchId");

                    // Send success email
                    String message = String.format("Successfully transferred region demarcation data from IDM to ERS. IDM Batch ID: %s, ERS Batch ID: %s, Filename: %s. Records processed: %d.", batchId, ersBatchId ?: "N/A", dynamicFilename, succeededIds.size());
                    sendEmail(message, csvContent, dynamicFilename);

                    // Send success SMS
                    String smsMessage = String.format("Region demarcation IDM batch %s transferred to ERS batch %s. Records: %d.", batchId, ersBatchId ?: "N/A", succeededIds.size());
                    sendSms(smsMessage);
                }

            } else {
                // ERS API call failed
                log.warn("==== RegionDemarcationToERSAggregator -> ERS API call failed for IDM batch $batchId. Determining retry/failure status for ${processingIds.size()} records.");
                // Separate records based on retry count
                records.each { region ->
                    int currentAttempts = (region.getAttempts() ?: 0) // Handle null attempts, default to 0
                    if (currentAttempts + 1 >= retryCount) {
                        failedIds.add(region.getId())
                    } else {
                        retryIds.add(region.getId())
                    }
                }

                // Update FAILED records (retry limit reached)
                if (!failedIds.isEmpty()) {
                    String updateToFailedQuery = "UPDATE " + TABLE + " SET status = ?, file_name = ? WHERE id IN (" + failedIds.join(',') + ")"
                    int updatedRowsFailed = jdbcTemplate.update(updateToFailedQuery, FAILED, dynamicFilename)
                    log.error("==== RegionDemarcationToERSAggregator -> Marked ${updatedRowsFailed} records as FAILED after reaching retry limit (${retryCount}) for IDM batch $batchId.");
                }

                // Update PENDING records (for retry) and increment attempts
                if (!retryIds.isEmpty()) {
                    String updateToRetryQuery = "UPDATE " + TABLE + " SET status = ?, attempts = attempts + 1 WHERE id IN (" + retryIds.join(',') + ")"
                    int updatedRowsPending = jdbcTemplate.update(updateToRetryQuery, PENDING)
                    log.warn("==== RegionDemarcationToERSAggregator -> Marked ${updatedRowsPending} records as PENDING for retry in IDM batch $batchId.");
                }
            }

        } catch (Exception e) {
            log.error("==== RegionDemarcationToERSAggregator -> Exception while processing IDM batch $batchId: ${e.getMessage()}", e);
            // Attempt to mark records as FAILED if an error occurred after marking them as PROCESSING
            if (!processingIds.isEmpty()) {
                try {
                    String updateToFailedQuery = "UPDATE " + TABLE + " SET status = ? WHERE id IN (" + processingIds.join(',') + ")"
                    int updatedRows = jdbcTemplate.update(updateToFailedQuery, FAILED)
                    log.error("==== RegionDemarcationToERSAggregator -> Exception occurred in IDM batch $batchId. Marked " + updatedRows + " records as FAILED.");
                } catch (Exception updateEx) {
                    log.error("==== RegionDemarcationToERSAggregator -> Failed to mark records as FAILED after exception in IDM batch $batchId: " + updateEx.getMessage(), updateEx);
                }
            }
        }
    }
}

class DemarcationRegion {
    private Long id;
    private String jobId;
    private String batchId;
    private String circle;
    private String region;
    private String cluster;
    private String territory;
    private String thana;
    private String status;
    private Timestamp createdOn;
    private Timestamp lastProcessRunsOn;
    private Timestamp processedDate;
    private String fileName;
    private Integer attempts;
    private String extraParams;

    Long getId() {
        return id
    }

    void setId(Long id) {
        this.id = id
    }

    String getJobId() {
        return jobId
    }

    void setJobId(String jobId) {
        this.jobId = jobId
    }

    String getBatchId() {
        return batchId
    }

    void setBatchId(String batchId) {
        this.batchId = batchId
    }

    String getCircle() {
        return circle
    }

    void setCircle(String circle) {
        this.circle = circle
    }

    String getRegion() {
        return region
    }

    void setRegion(String region) {
        this.region = region
    }

    String getCluster() {
        return cluster
    }

    void setCluster(String cluster) {
        this.cluster = cluster
    }

    String getTerritory() {
        return territory
    }

    void setTerritory(String territory) {
        this.territory = territory
    }

    String getThana() {
        return thana
    }

    void setThana(String thana) {
        this.thana = thana
    }

    String getStatus() {
        return status
    }

    void setStatus(String status) {
        this.status = status
    }

    Timestamp getCreatedOn() {
        return createdOn
    }

    void setCreatedOn(Timestamp createdOn) {
        this.createdOn = createdOn
    }

    Timestamp getLastProcessRunsOn() {
        return lastProcessRunsOn
    }

    void setLastProcessRunsOn(Timestamp lastProcessRunsOn) {
        this.lastProcessRunsOn = lastProcessRunsOn
    }

    Timestamp getProcessedDate() {
        return processedDate
    }

    void setProcessedDate(Timestamp processedDate) {
        this.processedDate = processedDate
    }

    String getFileName() {
        return fileName
    }

    void setFileName(String fileName) {
        this.fileName = fileName
    }

    Integer getAttempts() {
        return attempts
    }

    void setAttempts(Integer attempts) {
        this.attempts = attempts
    }

    String getExtraParams() {
        return extraParams
    }

    void setExtraParams(String extraParams) {
        this.extraParams = extraParams
    }
}