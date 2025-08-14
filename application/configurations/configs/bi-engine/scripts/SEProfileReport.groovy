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

@Slf4j
@Component
class SEProfileReport extends IReportScriptBaseService implements IReportScriptService {


    private final String query="{\"elasticIndex\":{\"indexName\":\"reseller_data_lake\",\"isDataWeeklyIndexed\":false},\"elasticQuery\":{\"query\":{\"bool\":{\"must\":[{\"bool\":{\"should\":[{\"term\":{\"dms.resellerInfo.additionalFields.channelId.keyword\":\"<:channel:>\"}},{\"wildcard\":{\"dms.resellerInfo.additionalFields.channelId.keyword\":{\"value\":\"<:channel:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.additionalFields.circle.keyword\":\"<-:circle:->\"}},{\"wildcard\":{\"dms.resellerInfo.additionalFields.circle.keyword\":{\"value\":\"<:circle:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.additionalFields.region.keyword\":\"<-:region:->\"}},{\"wildcard\":{\"dms.resellerInfo.additionalFields.region.keyword\":{\"value\":\"<:region:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.additionalFields.cluster.keyword\":\"<-:cluster:->\"}},{\"wildcard\":{\"dms.resellerInfo.additionalFields.cluster.keyword\":{\"value\":\"<:cluster:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.reseller.parentResellerId.keyword\":\"<-:partner_code_dh:->\"}},{\"wildcard\":{\"dms.resellerInfo.reseller.parentResellerId.keyword\":{\"value\":\"<:partner_code_dh:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.reseller.resellerId.keyword\":\"<-:partner_code_se:->\"}},{\"wildcard\":{\"dms.resellerInfo.reseller.resellerId.keyword\":{\"value\":\"<:partner_code_se:>\"}}}]}},{\"bool\":{\"should\":[{\"terms\":{\"dms.resellerInfo.reseller.status.keyword\":\"<-:status:->\"}},{\"wildcard\":{\"dms.resellerInfo.reseller.status.keyword\":{\"value\":\"<:status:>\"}}}]}},{\"term\":{\"dms.resellerInfo.reseller.resellerTypeId.keyword\":\"SE\"}}]}},\"script_fields\":{\"PARTNER_CODE_DH\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.parentResellerId')? doc['dms.resellerInfo.reseller.parentResellerId.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"PARTNER_NAME_DH\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.parentResellerName')? doc['dms.resellerInfo.reseller.parentResellerName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"CIRCLE\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.additionalFields.circle')? doc['dms.resellerInfo.additionalFields.circleName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"REGION\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.additionalFields.region')? doc['dms.resellerInfo.additionalFields.regionName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"CLUSTER\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.additionalFields.cluster')? doc['dms.resellerInfo.additionalFields.clusterName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"TERRITORY\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.additionalFields.territory')? doc['dms.resellerInfo.additionalFields.territoryName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"PARTNER_CODE_SE\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.resellerId')? doc['dms.resellerInfo.reseller.resellerId.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"PARTNER_NAME_SE\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.resellerName')? doc['dms.resellerInfo.reseller.resellerName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"SE ERS MSISDN\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.ersMsisdn')? doc['dms.resellerInfo.reseller.ersMsisdn.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"SE EMAIL\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.address.email')? doc['dms.resellerInfo.address.email.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"SE ERS NAME\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.dynamicData.number')? doc['dms.resellerInfo.dynamicData.number.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"SE IMEI\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.dynamicData.imei')? doc['dms.resellerInfo.dynamicData.imei.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"SE HHD STATUS\":{\"script\":{\"source\":\"if (params._source.containsKey('dms.resellerInfo.dynamicData.hhdStatus') && params._source['dms.resellerInfo.dynamicData.hhdStatus'].toString().toLowerCase() == 'true') { return 'Y'; } else { return 'N'; }\"}},\"SE STATUS\":{\"script\":{\"source\":\"if (params._source.containsKey('dms.resellerInfo.reseller.status')) { return (doc['dms.resellerInfo.reseller.status.keyword'].value).toUpperCase(); }else { return params['default']; }\",\"params\":{\"default\":\"\"}}},\"SE STATUS CHANGE DATE\":{\"script\":{\"lang\":\"painless\",\"source\":\"if (params._source.containsKey('timestamp')) { def date = doc['timestamp'].value.toInstant().toEpochMilli(); def outputFormat = new SimpleDateFormat('MM/dd/yyyy'); return outputFormat.format(new Date(date)); } else { return params['default']; }\",\"params\":{\"default\":\"\"}}},\"ROUTE_CODE\":{\"script\":{\"source\":\"if (params._source.containsKey('routeCode') && params._source['routeCode'] != 'N/A') { return doc['routeCode.keyword'].value; } else { return params['default']; }\",\"params\":{\"default\":\"\"}}},\"SE BASIC SALARY\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.dynamicData.salary')? doc['dms.resellerInfo.dynamicData.salary.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"CHANNEL\":{\"script\":{\"source\":\"params._source.containsKey('dms.resellerInfo.reseller.channelName')? doc['dms.resellerInfo.reseller.channelName.keyword'].value:params['default']\",\"params\":{\"default\":\"\"}}},\"SESUP Salary\":{\"script\":{\"source\":\"params['default']\",\"params\":{\"default\":\"\"}}},\"SE Onboard\":{\"script\":{\"source\":\"params['default']\",\"params\":{\"default\":\"\"}}},\"SE Deboard\":{\"script\":{\"source\":\"params['default']\",\"params\":{\"default\":\"\"}}},\"SE Freeze\":{\"script\":{\"source\":\"params['default']\",\"params\":{\"default\":\"\"}}},\"SESup Onboard\":{\"script\":{\"source\":\"params['default']\",\"params\":{\"default\":\"\"}}},\"SESup Deboard\":{\"script\":{\"source\":\"params['default']\",\"params\":{\"default\":\"\"}}},\"SESup Freeze\":{\"script\":{\"source\":\"params['default']\",\"params\":{\"default\":\"\"}}}}}}"

    @Autowired
    private RestHighLevelClient restHighLevelClient

    @Autowired
    ObjectMapper objectMapper

    // Define the order of columns for the report
    private final List<String> columnOrder = [
        "PARTNER_CODE_DH",
        "PARTNER_NAME_DH",
        "CIRCLE",
        "REGION",
        "CLUSTER",
        "TERRITORY",
        "PARTNER_CODE_SE",
        "PARTNER_NAME_SE",
        "SE ERS MSISDN",
        "SE EMAIL",
        "SE ERS NAME",
        "SE IMEI",
        "SE HHD STATUS",
        "SE STATUS",
        "SE STATUS CHANGE DATE",
        "ROUTE_CODE",
        "SE BASIC SALARY",
        "CHANNEL",
        "SESUP Salary",
        "SE Onboard",
        "SE Deboard",
        "SE Freeze",
        "SESup Onboard",
        "SESup Deboard",
        "SESup Freeze"
    ]

    @Override
    long getRowCount(ReportRequest reportRequest) {
        CountResponse countResponse = executeElasticsearchQueryForCount(reportRequest, objectMapper, restHighLevelClient, query)

        if (Objects.nonNull(countResponse) && countResponse.getCount() != 0)
            return countResponse.getCount()
        else
            return 0L
    }

    @Override
    ReportResponse getAllRecords(ReportRequest reportRequest) {
        log.info("GetAllRecords method called for: [" + reportRequest.getReportData().getReportName() + "]")

        // Define scroll size : Default value is 6000
        final int scrollSize = 6000

        // Get the searchResponse from elastic search
        Set<SearchResponse> searchResponses = executeElasticSearchQuery(reportRequest, objectMapper, restHighLevelClient, query, scrollSize)

        // Get Hits from searchResponse
        List<SearchHits> searchHits = getSearchHits(searchResponses)

        // Custom logic to get the required result-data from elastic search
        ReportResponse reportResponse
        if (!searchResponses.isEmpty() || !searchHits.isEmpty())
            reportResponse = getResult(searchHits, reportRequest)
        else
            reportResponse = invalidResponse("SearchResponse or SearchHits is null/empty while retrieving data from elastic search")

        return reportResponse
    }

    private ReportResponse getResult(List<SearchHits> searchHits, ReportRequest reportRequest) {
        log.info("Processing search hits for SE Profile Report")
        List<Map<String, Object>> resultList = new ArrayList<>()

        // Iterate over all search hits
        for (SearchHits hits : searchHits) {
            for (SearchHit hit : hits.getHits()) {
                Map<String, Object> resultMap = new LinkedHashMap<>() // Using LinkedHashMap to maintain order

                // Extract fields from the hit
                Map<String, Object> fields = hit.getFields()

                if (fields != null) {
                    // Add fields in the specified order
                    for (String column : columnOrder) {
                        if (fields.containsKey(column)) {
                            resultMap.put(column, (fields.get(column)).getValue())
                        } else {
                            resultMap.put(column, "") // Add empty string for missing fields
                        }
                    }
                }

                resultList.add(resultMap)
            }
        }

        // Create and return the report response
        ReportResponse reportResponse = new ReportResponse()
        reportResponse.setList(resultList)
        reportResponse.setResultCode(ResultCode.SUCCESS.getResultCode());
        reportResponse.setResultDescription(ResultCode.SUCCESS.name());
        reportResponse.setTotalRecordCount(resultList.size())
        return reportResponse
    }
}

