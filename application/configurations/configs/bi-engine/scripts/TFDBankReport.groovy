// Groovy script for TFDBankInfoReport

import com.fasterxml.jackson.databind.ObjectMapper
import com.seamless.customer.bi.engine.request.ReportRequest
import com.seamless.customer.bi.engine.response.ReportResponse
import com.seamless.customer.bi.engine.response.ResultCode
import com.seamless.customer.bi.engine.service.IReportScriptBaseService
import com.seamless.customer.bi.engine.service.IReportScriptService
import groovy.util.logging.Slf4j
import org.elasticsearch.action.search.SearchResponse
import org.elasticsearch.client.RestHighLevelClient
import org.elasticsearch.client.core.CountResponse
import org.elasticsearch.search.SearchHit
import org.elasticsearch.search.SearchHits
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource

import java.util.stream.Collectors

@Slf4j
@Component
class TFDBankReport extends IReportScriptBaseService implements IReportScriptService
{
    private final String query="{\"elasticIndex\":{\"indexName\":\"reseller_data_lake\",\"isDataWeeklyIndexed\":false},\"elasticQuery\":{\"script_fields\":{\"CHANNEL\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.channelName')? doc['dms.resellerInfo.reseller.channelName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"CIRCLE\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.additionalFields.circleName')? doc['dms.resellerInfo.additionalFields.circleName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"REGION\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.additionalFields.regionName')? doc['dms.resellerInfo.additionalFields.regionName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"CLUSTER\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.additionalFields.clusterName')? doc['dms.resellerInfo.additionalFields.clusterName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"TERRITORY\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.additionalFields.territoryName')? doc['dms.resellerInfo.additionalFields.territoryName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"PARTNER_CODE_DH\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.resellerId')? doc['dms.resellerInfo.reseller.resellerId.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"PARTNER_NAME_DH\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.resellerName')? doc['dms.resellerInfo.reseller.resellerName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"BANK_NAME\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.dynamicData.bankProperties.0.bank')? doc['dms.resellerInfo.reseller.dynamicData.bankProperties.0.bank.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"DISTRICT\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankDistrict')? doc['dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankDistrict.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"BRANCH_NAME\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankBranch')? doc['dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankBranch.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"ROUTING_NUMBER\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankRoutingNumber')? doc['dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankRoutingNumber.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"ACCOUNT_NUMBER\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankAccountNumber')? doc['dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankAccountNumber.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"AUTO_DEBIT_ACCEPTANCE\":{\"script\":{\"source\":\"if (doc.containsKey('dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankAutodebitFlag.keyword') && !doc['dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankAutodebitFlag.keyword'].empty) { return doc['dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankAutodebitFlag.keyword'].value == 'true' ? 'Yes' : 'No'; } else { return params.default; }\",\"params\":{\"default\":\"\"}}},\"AUTO_LOAN_ACCEPTANCE\":{\"script\":{\"source\":\"if (doc.containsKey('dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankAutoloanFlag.keyword') && !doc['dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankAutoloanFlag.keyword'].empty) { return doc['dms.resellerInfo.reseller.dynamicData.bankProperties.0.bankAutoloanFlag.keyword'].value == 'true' ? 'Yes' : 'No'; } else { return params.default; }\",\"params\":{\"default\":\"\"}}},\"LAST_MODIFIED\":{\"script\":{\"source\":\"if (params._source.containsKey('timestamp')) {def date = doc['timestamp'].value.toInstant().toEpochMilli();def outputFormat = new SimpleDateFormat('yyyy-MM-dd HH:mm:ss.S');return outputFormat.format(new Date(date));} else {return params['default'];}\",\"params\":{\"default\":\"\"}}},\"LAST_MODIFIED_BY\":{\"script\":{\"source\":\"params._source.containsKey('user.userId')? doc['user.userId.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"ONBOARDED_DATE\":{\"script\":{\"source\":\"params['default']\",\"params\":{\"default\":\"\"}}}},\"query\":{\"bool\":{\"must\":[{\"bool\":{\"should\":[{\"term\":{\"dms.resellerInfo.additionalFields.channelId.keyword\":\"<:channel:>\"}},{\"wildcard\":{\"dms.resellerInfo.additionalFields.channelId.keyword\":{\"value\":\"<:channel:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.additionalFields.circle.keyword\":\"<-:circle:->\"}},{\"wildcard\":{\"dms.resellerInfo.additionalFields.circle.keyword\":{\"value\":\"<:circle:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.additionalFields.region.keyword\":\"<-:region:->\"}},{\"wildcard\":{\"dms.resellerInfo.additionalFields.region.keyword\":{\"value\":\"<:region:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.additionalFields.cluster.keyword\":\"<-:cluster:->\"}},{\"wildcard\":{\"dms.resellerInfo.additionalFields.cluster.keyword\":{\"value\":\"<:cluster:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.additionalFields.territory.keyword\":\"<-:territory:->\"}},{\"wildcard\":{\"dms.resellerInfo.additionalFields.territory.keyword\":{\"value\":\"<:territory:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.reseller.resellerId.keyword\":\"<-:partner_code_dh:->\"}},{\"wildcard\":{\"dms.resellerInfo.reseller.resellerId.keyword\":{\"value\":\"<:partner_code_dh:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.reseller.resellerTypeId.keyword\":[\"DIST\"]}}]}}]}}}}"
 
    @Autowired
    private RestHighLevelClient restHighLevelClient;

    @Autowired
    ObjectMapper objectMapper;

     List<String> columnOrder = Arrays.asList(
            "CHANNEL", "CIRCLE", "REGION", "CLUSTER", "TERRITORY", 
            "PARTNER_CODE_DH", "PARTNER_NAME_DH", "BANK_NAME", "DISTRICT", 
            "BRANCH_NAME", "ROUTING_NUMBER", "ACCOUNT_NUMBER", "AUTO_DEBIT_ACCEPTANCE", 
            "AUTO_LOAN_ACCEPTANCE", "LAST_MODIFIED", "LAST_MODIFIED_BY", "ONBOARDED_DATE"
        );

    @Override
    long getRowCount(ReportRequest reportRequest)
    {
        CountResponse countResponse = executeElasticsearchQueryForCount(reportRequest, objectMapper, restHighLevelClient, query);

        if (Objects.nonNull(countResponse) && countResponse.getCount() !=0)
            return countResponse.getCount();
        else
            return 0L;
    }

    @Override
    ReportResponse getAllRecords(ReportRequest reportRequest)
    {
        log.info("GetAllRecords method called for: [" + reportRequest.getReportData().getReportName() + "]");

        //Define scroll size : Default value is 6000
        final int scrollSize = 6000;

        // Get the searchResponse from elastic search
        Set<SearchResponse> searchResponses = executeElasticSearchQuery(reportRequest, objectMapper, restHighLevelClient, query, scrollSize);

        // Get Hits from searchResponse
        List<SearchHits> searchHits = getSearchHits(searchResponses);

        // Custom logic to get the required result-data from elastic search
        ReportResponse reportResponse;
        if (!searchResponses.isEmpty() || !searchHits.isEmpty())
            reportResponse = getResult(searchHits, reportRequest);
        else
            reportResponse = invalidResponse("SearchResponse or SearchHits is null/empty while retrieving data from elastic search");

        return reportResponse;
    }

    private ReportResponse getResult(List<SearchHits> searchHits, ReportRequest reportRequest)
    {
        log.info("Processing search hits for TFD Bank Info Report");
        List<Map<String, Object>> resultList = new ArrayList<>();
        
        // Define the desired order of fields
       

        // Iterate over all search hits
        for (SearchHits hits : searchHits) {
            for (SearchHit hit : hits.getHits()) {
                Map<String, Object> resultMap = new LinkedHashMap<>();
                Map<String, Object> fields = hit.getFields();

                if (fields != null) {
                    // Add fields in the specified order
                    for (String column : columnOrder) {
                        if (fields.containsKey(column)) {
                            resultMap.put(column, (fields.get(column)).getValue());
                        } else {
                            resultMap.put(column, ""); // Add empty string for missing fields
                        }
                    }
                }
                
                resultList.add(resultMap);
            }
        }
        
        // Create and return the report response
        ReportResponse reportResponse = new ReportResponse();
        reportResponse.setList(resultList);
        reportResponse.setResultCode(ResultCode.SUCCESS.getResultCode());
        reportResponse.setResultDescription(ResultCode.SUCCESS.name());
        reportResponse.setTotalRecordCount(resultList.size());
        return reportResponse;
    }
}


