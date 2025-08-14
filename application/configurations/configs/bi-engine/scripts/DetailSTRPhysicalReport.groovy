import com.seamless.customer.bi.engine.request.ReportRequest
import com.seamless.customer.bi.engine.response.ReportResponse
import com.seamless.customer.bi.engine.response.ResultCode
import com.seamless.customer.bi.engine.service.IReportScriptBaseService
import com.seamless.customer.bi.engine.service.IReportScriptService
import groovy.util.logging.Slf4j
import org.elasticsearch.action.search.SearchRequest
import org.elasticsearch.action.search.SearchResponse
import org.elasticsearch.client.RequestOptions
import org.elasticsearch.client.RestHighLevelClient
import org.elasticsearch.index.query.QueryBuilders
import org.elasticsearch.index.query.BoolQueryBuilder
import org.elasticsearch.index.query.RangeQueryBuilder
import org.elasticsearch.search.aggregations.AggregationBuilders
import org.elasticsearch.search.aggregations.bucket.composite.CompositeAggregation
import org.elasticsearch.search.aggregations.bucket.composite.CompositeAggregationBuilder
import org.elasticsearch.search.aggregations.bucket.composite.TermsValuesSourceBuilder
import org.elasticsearch.search.builder.SearchSourceBuilder
import org.elasticsearch.script.Script
import org.elasticsearch.script.ScriptType
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter

@Slf4j
@Component
class DetailSTRPhysicalReport extends IReportScriptBaseService implements IReportScriptService {

    @Autowired
    private RestHighLevelClient restHighLevelClient

    // Define the order of columns for the report
    private final List<String> columnOrder = [
        "POS_CODE",
        "POS_NAME", 
        "PARTNER_CODE_SE",
        "PARTNER_NAME_SE",
        "POS_TYPE",
        "POS_CATEGORY",
        "POS_VALUE_CLASS",
        "PARTNER_CODE_DH",
        "PARTNER_NAME_DH",
        "CHANNEL",
        "CIRCLE",
        "REGION",
        "CLUSTER",
        "TERRITORY",
        "THANA",
        "ITEM_CODE",
        "DMS_ITEM_CODE",
        "ITEM_NAME",
        "PRODUCT_HEAD",
        "PRODUCT_GROUP",
        "SERIAL_NUMBER",
        "QUANTITY",
        "DELIVERY_DATE",
        "SECONDARY_RETURN_DATE",
        "ITEM_OWNER",
        "PRODUCT_TYPE",
        "DISTRICT",
        "REFERENCE_NO"
    ]

    @Override
    long getRowCount(ReportRequest reportRequest) {
        try {
            log.info("Calculating actual row count by running aggregation...")
            
            // Get the size parameter for aggregation bucket size
            Integer bucketSize = 10000
            
            long totalCount = 0
            Map<String, Object> afterKey = null
            int pageNum = 1
            
            while (true) {
                log.debug("Counting page {} - current total: {}", pageNum, totalCount)
                
                SearchRequest searchRequest = buildSearchRequest(reportRequest, afterKey, bucketSize)
                log.info("ROW COUNT - Submitting Elasticsearch query for page {}: {}", pageNum, searchRequest.source().toString())
                
                SearchResponse searchResponse = restHighLevelClient.search(searchRequest, RequestOptions.DEFAULT)
                
                if (searchResponse.getAggregations() != null) {
                    CompositeAggregation aggregation = searchResponse.getAggregations().get("order_serial_expansion")
                    if (aggregation != null) {
                        totalCount += aggregation.getBuckets().size()
                        afterKey = aggregation.afterKey()
                    } else {
                        log.warn("No composite aggregation found")
                        break
                    }
                } else {
                    log.warn("No aggregations found in search response")
                    break
                }
                
                pageNum++
                if (afterKey == null) break
            }
            
            log.info("Total row count calculated: {} rows across {} pages", totalCount, pageNum - 1)
            return totalCount
            
        } catch (Exception e) {
            log.error("Error getting row count", e)
            return 0L
        }
    }

    @Override
    ReportResponse getAllRecords(ReportRequest reportRequest) {
        log.info("GetAllRecords method called for: [{}]", reportRequest.getRawRequest().get("reportName"))

        try {
            // Check if this is a download request
            Map<String, Object> reportData = reportRequest.getRawRequest()
            boolean isDownload = reportData.containsKey("download")
            Integer bucketSize
            
            if (isDownload) {
                bucketSize = 10000 // Use hardcoded larger bucket size for downloads
                log.info("Download request detected. Using hardcoded bucket size: {} and will paginate through all pages", bucketSize)
            } else {
                bucketSize = getBucketSize(reportRequest)
                // Cap at 10000 for non-download requests
                if (bucketSize > 10000) {
                    bucketSize = 10000
                    log.info("Non-download request. Capping bucket size at: {} (single page only)", bucketSize)
                } else {
                    log.info("Non-download request. Using bucket size: {} (single page only)", bucketSize)
                }
            }
            
            List<Map<String, Object>> allResults = new ArrayList<>()
            Map<String, Object> afterKey = null
            int pageNum = 1
            
            while (true) {
                log.info("Processing page {} with {} results so far", pageNum, allResults.size())
                
                SearchRequest searchRequest = buildSearchRequest(reportRequest, afterKey, bucketSize)
                log.info("DATA RETRIEVAL - Submitting Elasticsearch query for page {}: {}", pageNum, searchRequest.source().toString())
                
                SearchResponse searchResponse = restHighLevelClient.search(searchRequest, RequestOptions.DEFAULT)
                
                List<Map<String, Object>> pageResults = processCompositeAggregation(searchResponse)
                allResults.addAll(pageResults)
                
                // Get afterKey for next page
                afterKey = getAfterKey(searchResponse)
                pageNum++
                
                log.debug("Page {} completed. Added {} results. Total: {}. HasNext: {}", 
                         pageNum - 1, pageResults.size(), allResults.size(), afterKey != null)
                
                // For non-download requests, process only the first page
                if (!isDownload) {
                    log.info("Non-download request completed. Fetched {} records from first page only.", allResults.size())
                    break
                }
                
                if (afterKey == null) break
            }
            
            if (isDownload) {
                log.info("Download completed: {} total records across {} pages", allResults.size(), pageNum - 1)
            } else {
                log.info("Single page request completed: {} records", allResults.size())
            }
            
            ReportResponse reportResponse = new ReportResponse()
            reportResponse.setList(allResults)
            reportResponse.setResultCode(ResultCode.SUCCESS.getResultCode())
            reportResponse.setResultDescription(ResultCode.SUCCESS.name())
            reportResponse.setTotalRecordCount(allResults.size())
            return reportResponse
            
        } catch (Exception e) {
            log.error("Error executing search request", e)
            return createErrorResponse("Error retrieving data from Elasticsearch: " + e.getMessage())
        }
    }

    private Integer getBucketSize(ReportRequest reportRequest) {
        Map<String, Object> reportData = reportRequest.getRawRequest()
        Integer bucketSize = 10000 // Default bucket size
        
        if (reportData.containsKey("size") && reportData.get("size") != null) {
            try {
                bucketSize = Integer.parseInt(reportData.get("size").toString().trim())
                log.info("Using custom bucket size: {}", bucketSize)
            } catch (NumberFormatException e) {
                log.warn("Invalid size parameter: {}. Using default bucket size: {}", reportData.get("size"), bucketSize)
            }
        }
        
        return bucketSize
    }

    private SearchRequest buildSearchRequest(ReportRequest reportRequest, Map<String, Object> afterKey, Integer bucketSize) {
        List<String> indexNames = getIndexName(reportRequest)
        SearchRequest searchRequest = new SearchRequest(indexNames.toArray(new String[0]))
        
        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder()
        searchSourceBuilder.size(0)
        
        BoolQueryBuilder queryBuilder = buildQuery(reportRequest)
        searchSourceBuilder.query(queryBuilder)
        
        CompositeAggregationBuilder aggregation = buildCompositeAggregation(afterKey, bucketSize, reportRequest)
        searchSourceBuilder.aggregation(aggregation)
        
        searchRequest.source(searchSourceBuilder)
        
        log.info("Built search request for indices {}: Query: {}, Aggregation: {}", 
                indexNames, queryBuilder.toString(), aggregation.toString())
        log.debug("Complete SearchRequest details: {}", searchRequest.toString())
        
        return searchRequest
    }

    private BoolQueryBuilder buildQuery(ReportRequest reportRequest) {
        BoolQueryBuilder queryBuilder = QueryBuilders.boolQuery()
        
        queryBuilder.must(QueryBuilders.termQuery("oms.orderType.keyword", "ISO"))
        queryBuilder.must(QueryBuilders.termQuery("oms.seller.sellerType.keyword", "DIST"))
        queryBuilder.must(QueryBuilders.termsQuery("oms.buyer.buyerType.keyword", "RET", "GPCF"))
        queryBuilder.must(QueryBuilders.termQuery("oms.invoices.invoice.invoiceEntries.product_group_type.keyword", "Physical"))
        
        BoolQueryBuilder employeeIdFilter = QueryBuilders.boolQuery()
            .must(QueryBuilders.existsQuery("oms.sender.employeeId"))
            .mustNot(QueryBuilders.termQuery("oms.sender.employeeId.keyword", "N/A"))
        queryBuilder.must(employeeIdFilter)
        
        Map<String, Object> reportData = reportRequest.getRawRequest()
        Object fromDateObj = reportData.get("fromDate")
        Object toDateObj = reportData.get("toDate")

        if (fromDateObj != null && toDateObj != null && !fromDateObj.toString().isEmpty() && !toDateObj.toString().isEmpty()) {
            String fromDateString = fromDateObj.toString().split('T')[0] + " 00:00:00"
            String toDateString = toDateObj.toString().split('T')[0] + " 23:59:59"
            
            RangeQueryBuilder dateRange = QueryBuilders.rangeQuery("timestamp")
                .gte(fromDateString)
                .lte(toDateString)
                .format("yyyy-MM-dd HH:mm:ss")
            queryBuilder.must(dateRange)
        }
        
        addDynamicFilters(queryBuilder, reportData)
        return queryBuilder
    }

    private void addDynamicFilters(BoolQueryBuilder queryBuilder, Map<String, Object> reportData) {
        addFilterIfExists(queryBuilder, reportData, "channel", "oms.buyer.additionalFields.channelId.keyword")
        addFilterIfExists(queryBuilder, reportData, "circle", "oms.buyer.additionalFields.circle.keyword")
        addFilterIfExists(queryBuilder, reportData, "region", "oms.buyer.additionalFields.region.keyword")
        addFilterIfExists(queryBuilder, reportData, "cluster", "oms.buyer.additionalFields.cluster.keyword")
        addFilterIfExists(queryBuilder, reportData, "territory", "oms.buyer.additionalFields.territory.keyword")
        addFilterIfExists(queryBuilder, reportData, "partner_code_dh", "oms.seller.id.keyword")
        addFilterIfExists(queryBuilder, reportData, "partner_code_se", "oms.sender.employeeId.keyword")
        addFilterIfExists(queryBuilder, reportData, "posCode", "oms.buyer.id.keyword")
        addFilterIfExists(queryBuilder, reportData, "productHeads", "oms.invoices.invoice.invoiceEntries.product_head_id", true)
        addFilterIfExists(queryBuilder, reportData, "productGroups", "oms.invoices.invoice.invoiceEntries.product_group_id", true)
        addFilterIfExists(queryBuilder, reportData, "itemName", "oms.invoices.invoice.invoiceEntries.productSKU.keyword")
    }

    private void addFilterIfExists(BoolQueryBuilder queryBuilder, Map<String, Object> reportData, 
                                  String paramName, String fieldName, boolean isInteger = false) {
        if (reportData.containsKey(paramName)) {
            Object value = reportData.get(paramName)
            if (value != null && !value.toString().isEmpty()) {
                String stringValue = value.toString().trim()
                
                BoolQueryBuilder fieldFilter = QueryBuilders.boolQuery()
                
                // Case 1: ALL - handle differently for integer and non-integer fields
                if ("ALL".equalsIgnoreCase(stringValue)) {
                    if (isInteger) {
                        fieldFilter.should(QueryBuilders.existsQuery(fieldName))
                    } else {
                        fieldFilter.should(QueryBuilders.wildcardQuery(fieldName, "*"))
                    }
                }
                // Case 2: Comma-separated values - use terms query
                else if (stringValue.contains(",")) {
                    if (isInteger) {
                        List<Integer> values = stringValue.split(",")
                            .collect { it.trim() }
                            .findAll { !it.isEmpty() }
                            .collect { Integer.parseInt(it) }
                        if (!values.isEmpty()) {
                            fieldFilter.should(QueryBuilders.termsQuery(fieldName, values))
                        }
                    } else {
                        List<String> values = stringValue.split(",")
                            .collect { it.trim() }
                            .findAll { !it.isEmpty() }
                        if (!values.isEmpty()) {
                            fieldFilter.should(QueryBuilders.termsQuery(fieldName, values))
                        }
                    }
                }
                // Case 3: Exact value - use term query
                else {
                    if (isInteger) {
                        fieldFilter.should(QueryBuilders.termQuery(fieldName, Integer.parseInt(stringValue)))
                    } else {
                        fieldFilter.should(QueryBuilders.termQuery(fieldName, stringValue))
                    }
                }
                
                queryBuilder.must(fieldFilter)
            }
        }
    }

    private CompositeAggregationBuilder buildCompositeAggregation(Map<String, Object> afterKey, Integer bucketSize, ReportRequest reportRequest) {
        Map<String, Object> reportData = reportRequest.getRawRequest();
        Map<String, Object> scriptParams = new HashMap<>();
        scriptParams.put("script_product_heads", reportData.get("productHeads"));
        scriptParams.put("script_product_groups", reportData.get("productGroups"));
        scriptParams.put("script_item_name", reportData.get("itemName"));

        String scriptSource = """
            def results = [];
            
            List productHeadsIntList = new ArrayList();
            if (params.script_product_heads != null) {
                String headsStr = params.script_product_heads.toString();
                if (!headsStr.isEmpty() && !"all".equalsIgnoreCase(headsStr)) {
                    String[] heads = headsStr.splitOnToken(',');
                    for (String head : heads) {
                        String trimmedHead = head.trim();
                        if (!trimmedHead.isEmpty()) {
                            try {
                                productHeadsIntList.add(Integer.parseInt(trimmedHead));
                            } catch (NumberFormatException e) {
                                // Ignore non-integer values
                            }
                        }
                    }
                }
            }

            List productGroupsIntList = new ArrayList();
            if (params.script_product_groups != null) {
                String groupsStr = params.script_product_groups.toString();
                if (!groupsStr.isEmpty() && !"all".equalsIgnoreCase(groupsStr)) {
                    String[] groups = groupsStr.splitOnToken(',');
                    for (String group : groups) {
                        String trimmedGroup = group.trim();
                        if (!trimmedGroup.isEmpty()) {
                            try {
                                productGroupsIntList.add(Integer.parseInt(trimmedGroup));
                            } catch (NumberFormatException e) {
                                // Ignore non-integer values
                            }
                        }
                    }
                }
            }

            List itemNameList = new ArrayList();
            if (params.script_item_name != null) {
                String itemsStr = params.script_item_name.toString();
                if (!itemsStr.isEmpty() && !"all".equalsIgnoreCase(itemsStr)) {
                    String[] items = itemsStr.splitOnToken(',');
                    for (String item : items) {
                        String trimmedItem = item.trim();
                        if (!trimmedItem.isEmpty()) {
                            itemNameList.add(trimmedItem);
                        }
                    }
                }
            }

            if (params._source['oms.invoices'] != null) { 
                def buyerId = params._source['oms.buyer.id'] ?: ''; 
                def buyerName = params._source['oms.buyer.name'] ?: ''; 
                def senderEmployeeId = params._source['oms.sender.employeeId'] ?: ''; 
                def senderEmployeeName = params._source['oms.sender.employeeName'] ?: ''; 
                def buyerPartnerType = params._source['oms.buyer.partnerTypes'] ?: ''; 
                def buyerPartnerCategory = params._source['oms.buyer.partnerCategories'] ?: ''; 
                def buyerPartnerValueClass = params._source['oms.buyer.partnerValueClasses'] ?: ''; 
                def sellerId = params._source['oms.seller.id'] ?: ''; 
                def sellerName = params._source['oms.seller.name'] ?: ''; 
                def buyerAdditionalFields = params._source['oms.buyer.additionalFields'] ?: [:]; 
                def channelName = buyerAdditionalFields['channelName'] ?: ''; 
                def circleName = buyerAdditionalFields['circleName'] ?: ''; 
                def regionName = buyerAdditionalFields['regionName'] ?: ''; 
                def clusterName = buyerAdditionalFields['clusterName'] ?: ''; 
                def territoryName = buyerAdditionalFields['territoryName'] ?: ''; 
                def marketThanaName = buyerAdditionalFields['marketThanaName'] ?: ''; 
                def adminDistrict = buyerAdditionalFields['adminDistrict'] ?: ''; 
                def timestamp = params._source['timestamp'] ?: ''; 
                def productType = 'Physical'; 
                for (invoice in params._source['oms.invoices']) { 
                    if (invoice['invoice.invoiceEntries'] != null) { 
                        for (entry in invoice['invoice.invoiceEntries']) { 
                            Integer entryProductHeadId = entry['product_head_id'];
                            Integer entryProductGroupId = entry['product_group_id'];
                            String productSku = entry['productSku'] ?: entry['productCode'] ?: '';

                            boolean headMatch = productHeadsIntList.isEmpty() || (entryProductHeadId != null && productHeadsIntList.contains(entryProductHeadId));
                            boolean groupMatch = productGroupsIntList.isEmpty() || (entryProductGroupId != null && productGroupsIntList.contains(entryProductGroupId));
                            boolean itemMatch = itemNameList.isEmpty() || (productSku != null && !productSku.isEmpty() && itemNameList.contains(productSku));

                            if (headMatch && groupMatch && itemMatch) {
                                def categoryPath = entry['categoryPath'] ?: ''; 
                                def pathParts = categoryPath.splitOnToken('/'); 
                                
                                def productOwner = '';
                                if (pathParts.length > 0) productOwner = pathParts[0];
                                
                                def productHead = '';
                                if (pathParts.length > 1) productHead = pathParts[1];
                                
                                def productGroup = '';
                                if (pathParts.length > 2) productGroup = pathParts[2];
                                
                                def productName = entry['productName'] ?: ''; 
                                def references = entry['invoiceEntryProperties'] != null && entry['invoiceEntryProperties']['msisdn'] != null ? entry['invoiceEntryProperties']['msisdn'] : ''; 
                                def referenceList = []; 
                                if (references != null && references != '') { 
                                    def splitReferences = references.splitOnToken(','); 
                                    for (ref in splitReferences) { 
                                        referenceList.add(ref.trim()); 
                                    } 
                                } 
                                if (entry['invoiceEntryProperties'] != null && entry['invoiceEntryProperties']['serials'] != null && entry['invoiceEntryProperties']['serials'] != '') { 
                                    def splitSerials = entry['invoiceEntryProperties']['serials'].splitOnToken(','); 
                                    for (int i = 0; i < splitSerials.length; i++) { 
                                        def serial = splitSerials[i].trim(); 
                                        def reference = i < referenceList.size() ? referenceList[i] : ''; 
                                        results.add(buyerId + ';' + buyerName + ';' + senderEmployeeId + ';' + senderEmployeeName + ';' + buyerPartnerType + ';' + buyerPartnerCategory + ';' + buyerPartnerValueClass + ';' + sellerId + ';' + sellerName + ';' + channelName + ';' + circleName + ';' + regionName + ';' + clusterName + ';' + territoryName + ';' + marketThanaName + ';' + productSku + ';' + productSku + ';' + productName + ';' + productHead + ';' + productGroup + ';' + serial + ';1;' + timestamp + ';' + productOwner + ';' + productType + ';' + adminDistrict + ';' + reference); 
                                    } 
                                } else { 
                                    def qty = (entry['quantity'] != null && entry['quantity'] != '' && entry['quantity'] != 'N/A') ? entry['quantity'] : '1'; 
                                    def reference = referenceList.size() > 0 ? referenceList[0] : ''; 
                                    results.add(buyerId + ';' + buyerName + ';' + senderEmployeeId + ';' + senderEmployeeName + ';' + buyerPartnerType + ';' + buyerPartnerCategory + ';' + buyerPartnerValueClass + ';' + sellerId + ';' + sellerName + ';' + channelName + ';' + circleName + ';' + regionName + ';' + clusterName + ';' + territoryName + ';' + marketThanaName + ';' + productSku + ';' + productSku + ';' + productName + ';' + productHead + ';' + productGroup + ';' + ';' + qty + ';' + timestamp + ';' + productOwner + ';' + productType + ';' + adminDistrict + ';' + reference); 
                                }
                            } 
                        } 
                    } 
                } 
            } 
            return results;
        """

        Script script = new Script(ScriptType.INLINE, "painless", scriptSource, scriptParams);
        
        def sources = [
            new TermsValuesSourceBuilder("data").script(script)
        ];
        
        CompositeAggregationBuilder compositeAgg = AggregationBuilders.composite("order_serial_expansion", sources)
            .size(bucketSize);
        
        if (afterKey != null) {
            compositeAgg.aggregateAfter(afterKey);
        }
        
        return compositeAgg;
    }

    private List<String> getIndexName(ReportRequest reportRequest) {
        Map<String, Object> reportData = reportRequest.getRawRequest()


        List<String> indexList = getIndexList(getFromDate(reportRequest), getToDate(reportRequest), "order_data_lake_", true)
        
        return indexList
    }

    private List<Map<String, Object>> processCompositeAggregation(SearchResponse searchResponse) {
        List<Map<String, Object>> resultList = new ArrayList<>()

        if (searchResponse.getAggregations() != null) {
            CompositeAggregation aggregation = searchResponse.getAggregations().get("order_serial_expansion")
            
            if (aggregation != null) {
                log.debug("Processing {} composite buckets", aggregation.getBuckets().size())
                
                for (CompositeAggregation.Bucket bucket : aggregation.getBuckets()) {
                    String bucketKey = bucket.getKey().get("data").toString()
                    log.trace("Processing bucket: {}", bucketKey)
                    
                    Map<String, Object> resultMap = parseRowData(bucketKey)
                    if (resultMap != null) {
                        resultList.add(resultMap)
                    }
                }
            } else {
                log.warn("No composite aggregation found with name 'order_serial_expansion'")
            }
        } else {
            log.warn("No aggregations found in search response")
        }

        return resultList
    }

    private Map<String, Object> getAfterKey(SearchResponse searchResponse) {
        if (searchResponse.getAggregations() != null) {
            CompositeAggregation aggregation = searchResponse.getAggregations().get("order_serial_expansion")
            if (aggregation != null) {
                return aggregation.afterKey()
            }
        }
        return null
    }

    private ReportResponse createErrorResponse(String message) {
        ReportResponse reportResponse = new ReportResponse()
        reportResponse.setList(new ArrayList<>())
        reportResponse.setResultCode(ResultCode.FAILURE.getResultCode())
        reportResponse.setResultDescription(message)
        reportResponse.setTotalRecordCount(0)
        return reportResponse
    }

    private Map<String, Object> parseRowData(String rowData) {
        try {
            String[] fields = rowData.split(";", -1)
            
            if (fields.length < 27) {
                log.warn("Insufficient fields in row data: {}. Expected 27, got {}", rowData, fields.length)
                return null
            }

            Map<String, Object> resultMap = new LinkedHashMap<>()

            resultMap.put("POS_CODE", fields[0] ?: "")
            resultMap.put("POS_NAME", fields[1] ?: "")
            resultMap.put("PARTNER_CODE_SE", fields[2] ?: "")
            resultMap.put("PARTNER_NAME_SE", fields[3] ?: "")
            resultMap.put("POS_TYPE", fields[4] ?: "")
            resultMap.put("POS_CATEGORY", fields[5] ?: "")
            resultMap.put("POS_VALUE_CLASS", fields[6] ?: "")
            resultMap.put("PARTNER_CODE_DH", fields[7] ?: "")
            resultMap.put("PARTNER_NAME_DH", fields[8] ?: "")
            resultMap.put("CHANNEL", fields[9] ?: "")
            resultMap.put("CIRCLE", fields[10] ?: "")
            resultMap.put("REGION", fields[11] ?: "")
            resultMap.put("CLUSTER", fields[12] ?: "")
            resultMap.put("TERRITORY", fields[13] ?: "")
            resultMap.put("THANA", fields[14] ?: "")
            resultMap.put("ITEM_CODE", fields[15] ?: "")
            resultMap.put("DMS_ITEM_CODE", fields[16] ?: "")
            resultMap.put("ITEM_NAME", fields[17] ?: "")
            resultMap.put("PRODUCT_HEAD", fields[18] ?: "")
            resultMap.put("PRODUCT_GROUP", fields[19] ?: "")
            resultMap.put("SERIAL_NUMBER", fields[20] ?: "")
            resultMap.put("QUANTITY", fields[21] ?: "")
            
            String deliveryDateStr = fields[22] ?: ""
            String formattedDeliveryDate = ""
            if (!deliveryDateStr.isEmpty()) {
                try {
                    ZonedDateTime zdt = ZonedDateTime.parse(deliveryDateStr)
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy")
                    formattedDeliveryDate = zdt.format(formatter)
                } catch (java.time.format.DateTimeParseException e) {
                    log.warn("Could not parse delivery date: {}. Using original value.", deliveryDateStr)
                    formattedDeliveryDate = deliveryDateStr
                }
            }
            resultMap.put("DELIVERY_DATE", formattedDeliveryDate)
            
            resultMap.put("SECONDARY_RETURN_DATE", "")
            resultMap.put("ITEM_OWNER", fields[23] ?: "")
            resultMap.put("PRODUCT_TYPE", fields[24] ?: "")
            resultMap.put("DISTRICT", fields[25] ?: "")
            resultMap.put("REFERENCE_NO", fields[26] ?: "")

            return resultMap

        } catch (Exception e) {
            log.error("Error parsing row data: {}", rowData, e)
            return null
        }
    }
}