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
class RETProfileReport extends IReportScriptBaseService implements IReportScriptService {


    private final String queryWithRetailerCode="""
    {
    "elasticIndex": {
        "indexName": "reseller_data_lake",
        "isDataWeeklyIndexed": false
    },
    "elasticQuery": {
        "script_fields": {
            "POS_CODE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.resellerId')? doc['dms.resellerInfo.reseller.resellerId.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "POS_NAME": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.resellerName')? doc['dms.resellerInfo.reseller.resellerName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ADDRESS": {
                "script": {
                    "lang": "painless",
                    "source": "if (params._source.containsKey('dms.resellerInfo.address.street') && params._source.containsKey('dms.resellerInfo.address.city') && params._source.containsKey('dms.resellerInfo.address.country')) { def street = doc['dms.resellerInfo.address.street.keyword']?.value ?: ''; def city = doc['dms.resellerInfo.address.city.keyword']?.value ?: ''; def country = doc['dms.resellerInfo.address.country.keyword']?.value ?: ''; def parts = [street, city, country]; def non_empty_parts = new ArrayList(); for (part in parts) { if (!part.isEmpty()) { non_empty_parts.add(part); } } return String.join(' ', non_empty_parts); } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "OWNER_NAME": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.name')? doc['dms.resellerInfo.dynamicData.name.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "OWNER_CONTACT_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.address.phone')? doc['dms.resellerInfo.address.phone.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "CONTACT_PERSON": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.contactPersonName')? doc['dms.resellerInfo.dynamicData.contactPersonName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "CONTACT_PERSON_MOBILE_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.contactPersonPhone')? doc['dms.resellerInfo.dynamicData.contactPersonPhone.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "FAX": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "EMAIL": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.address.email')? doc['dms.resellerInfo.address.email.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "REGISTRATION_DATE": {
                "script": {
                    "source": "if (params._source.containsKey('dms.resellerInfo.additionalFields.dealer_registration_date')) { String dateStr = doc['dms.resellerInfo.additionalFields.dealer_registration_date.keyword'].value; SimpleDateFormat inputFormat = new SimpleDateFormat('yyyy-MM-dd HH:mm:ss'); SimpleDateFormat outputFormat = new SimpleDateFormat('MM/dd/yyyy'); Date date = inputFormat.parse(dateStr); return outputFormat.format(date); } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "DEACTIVATION_DATE": {
                "script": {
                    "source": "if (params._source.containsKey('DEACTIVATION_DATE') && params._source['DEACTIVATION_DATE'] != 'N/A') { return doc['DEACTIVATION_DATE.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "COMMISSION_PAYMENT_MODE": {
                "script": {
                    "lang": "painless",
                    "source": "def categories = new ArrayList(); if(params._source.containsKey('dms.resellerInfo.dynamicData.commission.commissionPaymentMode')) {if (doc['dms.resellerInfo.dynamicData.commission.commissionPaymentMode.keyword']?.size() > 0) { for (category in doc['dms.resellerInfo.dynamicData.commission.commissionPaymentMode.keyword']) { if (category != null && !category.isEmpty()) { categories.add(category); } } } if (!categories.isEmpty()) { return String.join('|', categories); } else { return params['default']; }} else { return params['default'] }",
                    "params": {
                        "default": "Not Applicable"
                    }
                }
            },
        "COMMISSION_ERS_MSISDN": {
            "script": {
                "lang": "painless",
                "source": "def categories = new ArrayList(); if(params._source.containsKey('dms.resellerInfo.dynamicData.commissionProperties')) {if (doc['dms.resellerInfo.dynamicData.commissionProperties.commissionErsNumber.keyword']?.size() > 0) { for (category in doc['dms.resellerInfo.dynamicData.commissionProperties.commissionErsNumber.keyword']) { if (category != null && !category.isEmpty()) { categories.add(category); } } } if (!categories.isEmpty()) { return String.join('|', categories); } else { return params['default']; }} else { return params['default'] }",
                "params": {
                    "default": ""
                }
            }
        },
            "POS_GEO_CLASS": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.resellerGeoClass')? (doc['dms.resellerInfo.dynamicData.resellerGeoClass.keyword'].value).toUpperCase():params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
        "POS_CATEGORY": {
            "script": {
                "lang": "painless",
                "source": "def categories = new ArrayList(); if (params._source.containsKey('dms.resellerInfo.dynamicData.partnerProperties')){if (doc['dms.resellerInfo.dynamicData.partnerProperties.partnerCategory.keyword']?.size() > 0) { for (category in doc['dms.resellerInfo.dynamicData.partnerProperties.partnerCategory.keyword']) { if (category != null && !category.isEmpty()) { categories.add(category); } } } if (!categories.isEmpty()) { return String.join('|', categories); } else { return params['default']; }} else {return params['default'];}",
                "params": {
                    "default": ""
                }
            }
        },
        "POS_VALUE_CLASS": {
            "script": {
                "lang": "painless",
                "source": "def categories = new ArrayList(); if (params._source.containsKey('dms.resellerInfo.dynamicData.partnerProperties')){if (doc['dms.resellerInfo.dynamicData.partnerProperties.partnerValueClass.keyword']?.size() > 0) { for (category in doc['dms.resellerInfo.dynamicData.partnerProperties.partnerValueClass.keyword']) { if (category != null && !category.isEmpty()) { categories.add(category); } } } if (!categories.isEmpty()) { return String.join('|', categories); } else { return params['default']; }} else {return params['default'];}",
                "params": {
                    "default": ""
                }
            }
        },
        "POS_TYPE": {
            "script": {
                "lang": "painless",
                "source": "def categories = new ArrayList(); if (params._source.containsKey('dms.resellerInfo.dynamicData.partnerProperties')){if (doc['dms.resellerInfo.dynamicData.partnerProperties.partnerType.keyword']?.size() > 0) { for (category in doc['dms.resellerInfo.dynamicData.partnerProperties.partnerType.keyword']) { if (category != null && !category.isEmpty()) { categories.add(category); } } } if (!categories.isEmpty()) { return String.join('|', categories); } else { return params['default']; }} else {return params['default'];}",
                "params": {
                    "default": ""
                }
            }
        },
            "SERVICE_TYPE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.resellerServiceType')? doc['dms.resellerInfo.dynamicData.resellerServiceType.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "GPDC": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "CIRCLE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.circleName')? doc['dms.resellerInfo.additionalFields.circleName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "REGION": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.regionName')? doc['dms.resellerInfo.additionalFields.regionName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "CLUSTER": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.clusterName')? doc['dms.resellerInfo.additionalFields.clusterName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "TERRITORY": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.territoryName')? doc['dms.resellerInfo.additionalFields.territoryName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ROUTE_CODE": {
                "script": {
                    "source": "if (params._source.containsKey('routeCode') && params._source['routeCode'] != 'N/A') { return doc['routeCode.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ROUTE": {
                "script": {
                    "source": "if (params._source.containsKey('routeName') && params._source['routeName'] != 'N/A') { return doc['routeName.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ROUTE_FREQUENCY": {
                "script": {
                    "source": "if (params._source.containsKey('routeFrequency') && params._source['routeFrequency'] != 'N/A') { return doc['routeFrequency.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "DISTRICT": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.adminDistrict')? doc['dms.resellerInfo.additionalFields.adminDistrict.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "THANA": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.marketThanaName')? doc['dms.resellerInfo.additionalFields.marketThanaName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "THANA_UNIQUE_CODE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.marketThana')? doc['dms.resellerInfo.additionalFields.marketThana.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "THANA_TYPE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.resellerGeoClass')? (doc['dms.resellerInfo.dynamicData.resellerGeoClass.keyword'].value).toUpperCase():params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "PARTNER_CODE_SE": {
                "script": {
                    "source": "if (params._source.containsKey('se_reseller_id') && params._source['se_reseller_id'] != 'N/A') { return doc['se_reseller_id.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "PARTNER_NAME_SE": {
                "script": {
                    "source": "if (params._source.containsKey('se_name') && params._source['se_name'] != 'N/A') { return doc['se_name.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SE_ERS_MSISDN": {
                "script": {
                    "source": "if (params._source.containsKey('se_msisdn') && params._source['se_msisdn'] != 'N/A') { return doc['se_msisdn.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SE_STATUS": {
                "script": {
                    "source": "if (params._source.containsKey('se_status') && params._source['se_status'] != 'N/A') { if ('Active' == doc['se_status.keyword'].value) { return 'ACTIVE' } else return 'INACTIVE'; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SE_SUPERVISOR_CODE": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SE_SUPERVISOR_NAME": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "BANK": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "BRANCH": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ACCOUNT_NO": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "RETAILER_STATUS": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.status')? ((doc['dms.resellerInfo.reseller.status.keyword'].value == 'Active')?params['active']:params['deboarded']):params['default']",
                    "params": {
                        "default": "",
                        "active": "ACTIVE",
                        "deboarded": "DEBOARDED"
                    }
                }
            },
            "TELCO_STATUS": {
                "script": {
                    "lang": "painless",
                    "source": "String status = 'NA'; String fieldName = 'dms.resellerInfo.dynamicData.pos'; if (params._source.containsKey(fieldName) && params._source[fieldName] instanceof List) { List posList = params._source[fieldName]; if (!posList.isEmpty()) { for (def item : posList) { if (item instanceof Map && item.containsKey('partnerType')) { if (item.partnerType.toString().equalsIgnoreCase('Telco')) { status = 'ACTIVE'; break; } } } } } return status;"
                }
            },
            "ERS_STATUS": {
                "script": {
                    "lang": "painless",
                    "source": "String status = 'NA'; String fieldName = 'dms.resellerInfo.dynamicData.pos'; if (params._source.containsKey(fieldName) && params._source[fieldName] instanceof List) { List posList = params._source[fieldName]; if (!posList.isEmpty()) { for (def item : posList) { if (item instanceof Map && item.containsKey('partnerType')) { if (item.partnerType.toString().equalsIgnoreCase('ERS')) { status = 'ACTIVE'; break; } } } } } return status;"
                }
            },
            "MFS_STATUS": {
                "script": {
                    "lang": "painless",
                    "source": "String status = 'NA'; String fieldName = 'dms.resellerInfo.dynamicData.pos'; if (params._source.containsKey(fieldName) && params._source[fieldName] instanceof List) { List posList = params._source[fieldName]; if (!posList.isEmpty()) { for (def item : posList) { if (item instanceof Map && item.containsKey('partnerType')) { if (item.partnerType.toString().equalsIgnoreCase('MFS')) { status = 'ACTIVE'; break; } } } } } return status;"
                }
            },
            "SC_STATUS": {
                "script": {
                    "lang": "painless",
                    "source": "String status = 'NA'; String fieldName = 'dms.resellerInfo.dynamicData.pos'; if (params._source.containsKey(fieldName) && params._source[fieldName] instanceof List) { List posList = params._source[fieldName]; if (!posList.isEmpty()) { for (def item : posList) { if (item instanceof Map && item.containsKey('partnerType')) { if (item.partnerType.toString().equalsIgnoreCase('SC')) { status = 'ACTIVE'; break; } } } } } return status;"
                }
            },
            "STP": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.stpFlag')? ((doc['dms.resellerInfo.dynamicData.stpFlag.keyword'].value == 'yes')?params['yes']:params['no']):params['default']",
                    "params": {
                        "default": "",
                        "yes": "YES",
                        "no": "NO"
                    }
                }
            },
            "DRC": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.drcCommissionFlag')? ((doc['dms.resellerInfo.dynamicData.drcCommissionFlag.keyword'].value == 'yes')?params['yes']:params['no']):params['default']",
                    "params": {
                        "default": "",
                        "yes": "YES",
                        "no": "NO"
                    }
                }
            },
            "PARTNER_CODE_DH": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.parentResellerId')? doc['dms.resellerInfo.reseller.parentResellerId.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "PARTNER_NAME_DH": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.parentResellerName')? doc['dms.resellerInfo.reseller.parentResellerName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "DISTRIBUTOR_MSISDN": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.parentResellerMSISDN')? doc['dms.resellerInfo.reseller.parentResellerMSISDN.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ADMIN_THANA": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.adminThana')? doc['dms.resellerInfo.additionalFields.adminThana.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "RTR_LEGACY_CODE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.customerNumber')? doc['dms.resellerInfo.dynamicData.customerNumber.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ERS_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.ersMsisdn')? doc['dms.resellerInfo.reseller.ersMsisdn.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "MFS_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.mfsMsisdn')? doc['dms.resellerInfo.reseller.mfsMsisdn.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "BIOSCANNER_TAB_IMEI_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.imei')? doc['dms.resellerInfo.dynamicData.imei.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SCANNER_NUMBER_TAB_SIM_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.scannerNumber')? doc['dms.resellerInfo.dynamicData.scannerNumber.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "CHANNEL": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.channelName')? doc['dms.resellerInfo.reseller.channelName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "TELCO_ONBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('TELCO_ONBOARD_DATE')? doc['TELCO_ONBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "TELCO_DEBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('TELCO_DEBOARD_DATE')? doc['TELCO_DEBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SC_ONBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('SC_ONBOARD_DATE')? doc['SC_ONBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SC_DEBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('SC_DEBOARD_DATE')? doc['SC_DEBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ERS_ONBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('ERS_ONBOARD_DATE')? doc['ERS_ONBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ERS_DEBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('ERS_DEBOARD_DATE')? doc['ERS_DEBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "MFS_DEBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('MFS_DEBOARD_DATE')? doc['MFS_DEBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "MFS_ONBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('MFS_ONBOARD_DATE')? doc['MFS_ONBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "LATITUDE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.latitude')? doc['dms.resellerInfo.dynamicData.latitude.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "LONGITUDE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.longitude')? doc['dms.resellerInfo.dynamicData.longitude.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "TIN_NUMBER": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.tinNumber')? doc['dms.resellerInfo.dynamicData.tinNumber.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "TRADE_LICENSE_NUMBER": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.tlNumber')? doc['dms.resellerInfo.dynamicData.tlNumber.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "VAT_REGISTRATION_NUMBER": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.binNumber')? doc['dms.resellerInfo.dynamicData.binNumber.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SHOP_SIZE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.shopSize')? doc['dms.resellerInfo.dynamicData.shopSize.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "WEEKLY_HOLIDAY": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.weeklyHoliday')? doc['dms.resellerInfo.dynamicData.weeklyHoliday.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SPACE_RENTAL_AGREEMENT_END_DATE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.rentalAgreementEndDate')? doc['dms.resellerInfo.dynamicData.rentalAgreementEndDate.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "LANDOWNER_NAME": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.landownerName')? doc['dms.resellerInfo.dynamicData.landownerName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "LANDOWNER_CONTACT_NUMBER": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.landownerContact')? doc['dms.resellerInfo.dynamicData.landownerContact.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "MONTHLY_RENT": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.monthlyRent')? doc['dms.resellerInfo.dynamicData.monthlyRent.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "RENTAL_ADVANCE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.rentalAdvance')? doc['dms.resellerInfo.dynamicData.rentalAdvance.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            }
        },
        "query": {
            "bool": {
                "must": [
                    {
                        "bool": {
                            "should": [
                                {
                                    "term": {
                                        "dms.resellerInfo.additionalFields.channelId.keyword": "<:channel:>"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.additionalFields.channelId.keyword": {
                                            "value": "<:channel:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.additionalFields.circle.keyword": "<-:circle:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.additionalFields.circle.keyword": {
                                            "value": "<:circle:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.additionalFields.region.keyword": "<-:region:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.additionalFields.region.keyword": {
                                            "value": "<:region:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.additionalFields.cluster.keyword": "<-:cluster:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.additionalFields.cluster.keyword": {
                                            "value": "<:cluster:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.additionalFields.territory.keyword": "<-:territory:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.additionalFields.territory.keyword": {
                                            "value": "<:territory:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.reseller.parentResellerId.keyword": "<-:partner_code_dh:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.reseller.parentResellerId.keyword": {
                                            "value": "<:partner_code_dh:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "term": {
                                        "dms.resellerInfo.reseller.resellerId.keyword": {
                                            "value": "<:partner_code_rtr:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.reseller.status.keyword": "<-:status:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.reseller.status.keyword": {
                                            "value": "<:status:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.reseller.resellerTypeId.keyword": [
                                            "RET",
                                            "GPCF"
                                        ]
                                    }
                                }
                            ]
                        }
                    }
                ]
            }
        }
    }
}
    """

    private final String queryWithoutRetailerCode="""
{
    "elasticIndex": {
        "indexName": "reseller_data_lake",
        "isDataWeeklyIndexed": false
    },
    "elasticQuery": {
        "script_fields": {
            "POS_CODE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.resellerId')? doc['dms.resellerInfo.reseller.resellerId.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "POS_NAME": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.resellerName')? doc['dms.resellerInfo.reseller.resellerName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ADDRESS": {
                "script": {
                    "lang": "painless",
                    "source": "if (params._source.containsKey('dms.resellerInfo.address.street') && params._source.containsKey('dms.resellerInfo.address.city') && params._source.containsKey('dms.resellerInfo.address.country')) { def street = doc['dms.resellerInfo.address.street.keyword']?.value ?: ''; def city = doc['dms.resellerInfo.address.city.keyword']?.value ?: ''; def country = doc['dms.resellerInfo.address.country.keyword']?.value ?: ''; def parts = [street, city, country]; def non_empty_parts = new ArrayList(); for (part in parts) { if (!part.isEmpty()) { non_empty_parts.add(part); } } return String.join(' ', non_empty_parts); } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "OWNER_NAME": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.name')? doc['dms.resellerInfo.dynamicData.name.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "OWNER_CONTACT_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.address.phone')? doc['dms.resellerInfo.address.phone.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "CONTACT_PERSON": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.contactPersonName')? doc['dms.resellerInfo.dynamicData.contactPersonName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "CONTACT_PERSON_MOBILE_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.contactPersonPhone')? doc['dms.resellerInfo.dynamicData.contactPersonPhone.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "FAX": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "EMAIL": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.address.email')? doc['dms.resellerInfo.address.email.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "REGISTRATION_DATE": {
                "script": {
                    "source": "if (params._source.containsKey('dms.resellerInfo.additionalFields.dealer_registration_date')) { String dateStr = doc['dms.resellerInfo.additionalFields.dealer_registration_date.keyword'].value; SimpleDateFormat inputFormat = new SimpleDateFormat('yyyy-MM-dd HH:mm:ss'); SimpleDateFormat outputFormat = new SimpleDateFormat('MM/dd/yyyy'); Date date = inputFormat.parse(dateStr); return outputFormat.format(date); } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "DEACTIVATION_DATE": {
                "script": {
                    "source": "if (params._source.containsKey('DEACTIVATION_DATE') && params._source['DEACTIVATION_DATE'] != 'N/A') { return doc['DEACTIVATION_DATE.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "COMMISSION_PAYMENT_MODE": {
                "script": {
                    "lang": "painless",
                    "source": "def categories = new ArrayList(); if(params._source.containsKey('dms.resellerInfo.dynamicData.commission.commissionPaymentMode')) {if (doc['dms.resellerInfo.dynamicData.commission.commissionPaymentMode.keyword']?.size() > 0) { for (category in doc['dms.resellerInfo.dynamicData.commission.commissionPaymentMode.keyword']) { if (category != null && !category.isEmpty()) { categories.add(category); } } } if (!categories.isEmpty()) { return String.join('|', categories); } else { return params['default']; }} else { return params['default'] }",
                    "params": {
                        "default": "Not Applicable"
                    }
                }
            },
        "COMMISSION_ERS_MSISDN": {
            "script": {
                "lang": "painless",
                "source": "def categories = new ArrayList(); if(params._source.containsKey('dms.resellerInfo.dynamicData.commissionProperties')) {if (doc['dms.resellerInfo.dynamicData.commissionProperties.commissionErsNumber.keyword']?.size() > 0) { for (category in doc['dms.resellerInfo.dynamicData.commissionProperties.commissionErsNumber.keyword']) { if (category != null && !category.isEmpty()) { categories.add(category); } } } if (!categories.isEmpty()) { return String.join('|', categories); } else { return params['default']; }} else { return params['default'] }",
                "params": {
                    "default": ""
                }
            }
        },
            "POS_GEO_CLASS": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.resellerGeoClass')? (doc['dms.resellerInfo.dynamicData.resellerGeoClass.keyword'].value).toUpperCase():params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
        "POS_CATEGORY": {
            "script": {
                "lang": "painless",
                "source": "def categories = new ArrayList(); if (params._source.containsKey('dms.resellerInfo.dynamicData.partnerProperties')){if (doc['dms.resellerInfo.dynamicData.partnerProperties.partnerCategory.keyword']?.size() > 0) { for (category in doc['dms.resellerInfo.dynamicData.partnerProperties.partnerCategory.keyword']) { if (category != null && !category.isEmpty()) { categories.add(category); } } } if (!categories.isEmpty()) { return String.join('|', categories); } else { return params['default']; }} else {return params['default'];}",
                "params": {
                    "default": ""
                }
            }
        },
        "POS_VALUE_CLASS": {
            "script": {
                "lang": "painless",
                "source": "def categories = new ArrayList(); if (params._source.containsKey('dms.resellerInfo.dynamicData.partnerProperties')){if (doc['dms.resellerInfo.dynamicData.partnerProperties.partnerValueClass.keyword']?.size() > 0) { for (category in doc['dms.resellerInfo.dynamicData.partnerProperties.partnerValueClass.keyword']) { if (category != null && !category.isEmpty()) { categories.add(category); } } } if (!categories.isEmpty()) { return String.join('|', categories); } else { return params['default']; }} else {return params['default'];}",
                "params": {
                    "default": ""
                }
            }
        },
        "POS_TYPE": {
            "script": {
                "lang": "painless",
                "source": "def categories = new ArrayList(); if (params._source.containsKey('dms.resellerInfo.dynamicData.partnerProperties')){if (doc['dms.resellerInfo.dynamicData.partnerProperties.partnerType.keyword']?.size() > 0) { for (category in doc['dms.resellerInfo.dynamicData.partnerProperties.partnerType.keyword']) { if (category != null && !category.isEmpty()) { categories.add(category); } } } if (!categories.isEmpty()) { return String.join('|', categories); } else { return params['default']; }} else {return params['default'];}",
                "params": {
                    "default": ""
                }
            }
        },
            "SERVICE_TYPE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.resellerServiceType')? doc['dms.resellerInfo.dynamicData.resellerServiceType.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "GPDC": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "CIRCLE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.circleName')? doc['dms.resellerInfo.additionalFields.circleName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "REGION": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.regionName')? doc['dms.resellerInfo.additionalFields.regionName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "CLUSTER": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.clusterName')? doc['dms.resellerInfo.additionalFields.clusterName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "TERRITORY": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.territoryName')? doc['dms.resellerInfo.additionalFields.territoryName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ROUTE_CODE": {
                "script": {
                    "source": "if (params._source.containsKey('routeCode') && params._source['routeCode'] != 'N/A') { return doc['routeCode.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ROUTE": {
                "script": {
                    "source": "if (params._source.containsKey('routeName') && params._source['routeName'] != 'N/A') { return doc['routeName.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ROUTE_FREQUENCY": {
                "script": {
                    "source": "if (params._source.containsKey('routeFrequency') && params._source['routeFrequency'] != 'N/A') { return doc['routeFrequency.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "DISTRICT": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.adminDistrict')? doc['dms.resellerInfo.additionalFields.adminDistrict.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "THANA": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.marketThanaName')? doc['dms.resellerInfo.additionalFields.marketThanaName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "THANA_UNIQUE_CODE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.marketThana')? doc['dms.resellerInfo.additionalFields.marketThana.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "THANA_TYPE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.resellerGeoClass')? (doc['dms.resellerInfo.dynamicData.resellerGeoClass.keyword'].value).toUpperCase():params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "PARTNER_CODE_SE": {
                "script": {
                    "source": "if (params._source.containsKey('se_reseller_id') && params._source['se_reseller_id'] != 'N/A') { return doc['se_reseller_id.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "PARTNER_NAME_SE": {
                "script": {
                    "source": "if (params._source.containsKey('se_name') && params._source['se_name'] != 'N/A') { return doc['se_name.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SE_ERS_MSISDN": {
                "script": {
                    "source": "if (params._source.containsKey('se_msisdn') && params._source['se_msisdn'] != 'N/A') { return doc['se_msisdn.keyword'].value; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SE_STATUS": {
                "script": {
                    "source": "if (params._source.containsKey('se_status') && params._source['se_status'] != 'N/A') { if ('Active' == doc['se_status.keyword'].value) { return 'ACTIVE' } else return 'INACTIVE'; } else { return params['default']; }",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SE_SUPERVISOR_CODE": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SE_SUPERVISOR_NAME": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "BANK": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "BRANCH": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ACCOUNT_NO": {
                "script": {
                    "source": "params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "RETAILER_STATUS": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.status')? ((doc['dms.resellerInfo.reseller.status.keyword'].value == 'Active')?params['active']:params['deboarded']):params['default']",
                    "params": {
                        "default": "",
                        "active": "ACTIVE",
                        "deboarded": "DEBOARDED"
                    }
                }
            },
            "TELCO_STATUS": {
                "script": {
                    "lang": "painless",
                    "source": "String status = 'NA'; String fieldName = 'dms.resellerInfo.dynamicData.pos'; if (params._source.containsKey(fieldName) && params._source[fieldName] instanceof List) { List posList = params._source[fieldName]; if (!posList.isEmpty()) { for (def item : posList) { if (item instanceof Map && item.containsKey('partnerType')) { if (item.partnerType.toString().equalsIgnoreCase('Telco')) { status = 'ACTIVE'; break; } } } } } return status;"
                }
            },
            "ERS_STATUS": {
                "script": {
                    "lang": "painless",
                    "source": "String status = 'NA'; String fieldName = 'dms.resellerInfo.dynamicData.pos'; if (params._source.containsKey(fieldName) && params._source[fieldName] instanceof List) { List posList = params._source[fieldName]; if (!posList.isEmpty()) { for (def item : posList) { if (item instanceof Map && item.containsKey('partnerType')) { if (item.partnerType.toString().equalsIgnoreCase('ERS')) { status = 'ACTIVE'; break; } } } } } return status;"
                }
            },
            "MFS_STATUS": {
                "script": {
                    "lang": "painless",
                    "source": "String status = 'NA'; String fieldName = 'dms.resellerInfo.dynamicData.pos'; if (params._source.containsKey(fieldName) && params._source[fieldName] instanceof List) { List posList = params._source[fieldName]; if (!posList.isEmpty()) { for (def item : posList) { if (item instanceof Map && item.containsKey('partnerType')) { if (item.partnerType.toString().equalsIgnoreCase('MFS')) { status = 'ACTIVE'; break; } } } } } return status;"
                }
            },
            "SC_STATUS": {
                "script": {
                    "lang": "painless",
                    "source": "String status = 'NA'; String fieldName = 'dms.resellerInfo.dynamicData.pos'; if (params._source.containsKey(fieldName) && params._source[fieldName] instanceof List) { List posList = params._source[fieldName]; if (!posList.isEmpty()) { for (def item : posList) { if (item instanceof Map && item.containsKey('partnerType')) { if (item.partnerType.toString().equalsIgnoreCase('SC')) { status = 'ACTIVE'; break; } } } } } return status;"
                }
            },
            "STP": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.stpFlag')? ((doc['dms.resellerInfo.dynamicData.stpFlag.keyword'].value == 'yes')?params['yes']:params['no']):params['default']",
                    "params": {
                        "default": "",
                        "yes": "YES",
                        "no": "NO"
                    }
                }
            },
            "DRC": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.drcCommissionFlag')? ((doc['dms.resellerInfo.dynamicData.drcCommissionFlag.keyword'].value == 'yes')?params['yes']:params['no']):params['default']",
                    "params": {
                        "default": "",
                        "yes": "YES",
                        "no": "NO"
                    }
                }
            },
            "PARTNER_CODE_DH": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.parentResellerId')? doc['dms.resellerInfo.reseller.parentResellerId.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "PARTNER_NAME_DH": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.parentResellerName')? doc['dms.resellerInfo.reseller.parentResellerName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "DISTRIBUTOR_MSISDN": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.parentResellerMSISDN')? doc['dms.resellerInfo.reseller.parentResellerMSISDN.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ADMIN_THANA": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.additionalFields.adminThana')? doc['dms.resellerInfo.additionalFields.adminThana.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "RTR_LEGACY_CODE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.customerNumber')? doc['dms.resellerInfo.dynamicData.customerNumber.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ERS_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.ersMsisdn')? doc['dms.resellerInfo.reseller.ersMsisdn.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "MFS_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.mfsMsisdn')? doc['dms.resellerInfo.reseller.mfsMsisdn.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "BIOSCANNER_TAB_IMEI_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.imei')? doc['dms.resellerInfo.dynamicData.imei.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SCANNER_NUMBER_TAB_SIM_NO": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.scannerNumber')? doc['dms.resellerInfo.dynamicData.scannerNumber.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "CHANNEL": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.reseller.channelName')? doc['dms.resellerInfo.reseller.channelName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "TELCO_ONBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('TELCO_ONBOARD_DATE')? doc['TELCO_ONBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "TELCO_DEBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('TELCO_DEBOARD_DATE')? doc['TELCO_DEBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SC_ONBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('SC_ONBOARD_DATE')? doc['SC_ONBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SC_DEBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('SC_DEBOARD_DATE')? doc['SC_DEBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ERS_ONBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('ERS_ONBOARD_DATE')? doc['ERS_ONBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "ERS_DEBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('ERS_DEBOARD_DATE')? doc['ERS_DEBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "MFS_DEBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('MFS_DEBOARD_DATE')? doc['MFS_DEBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "MFS_ONBOARD_DATE": {
                "script": {
                    "source": "params._source.containsKey('MFS_ONBOARD_DATE')? doc['MFS_ONBOARD_DATE.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "LATITUDE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.latitude')? doc['dms.resellerInfo.dynamicData.latitude.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "LONGITUDE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.longitude')? doc['dms.resellerInfo.dynamicData.longitude.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "TIN_NUMBER": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.tinNumber')? doc['dms.resellerInfo.dynamicData.tinNumber.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "TRADE_LICENSE_NUMBER": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.tlNumber')? doc['dms.resellerInfo.dynamicData.tlNumber.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "VAT_REGISTRATION_NUMBER": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.binNumber')? doc['dms.resellerInfo.dynamicData.binNumber.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SHOP_SIZE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.shopSize')? doc['dms.resellerInfo.dynamicData.shopSize.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "WEEKLY_HOLIDAY": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.weeklyHoliday')? doc['dms.resellerInfo.dynamicData.weeklyHoliday.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "SPACE_RENTAL_AGREEMENT_END_DATE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.rentalAgreementEndDate')? doc['dms.resellerInfo.dynamicData.rentalAgreementEndDate.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "LANDOWNER_NAME": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.landownerName')? doc['dms.resellerInfo.dynamicData.landownerName.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "LANDOWNER_CONTACT_NUMBER": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.landownerContact')? doc['dms.resellerInfo.dynamicData.landownerContact.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "MONTHLY_RENT": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.monthlyRent')? doc['dms.resellerInfo.dynamicData.monthlyRent.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            },
            "RENTAL_ADVANCE": {
                "script": {
                    "source": "params._source.containsKey('dms.resellerInfo.dynamicData.rentalAdvance')? doc['dms.resellerInfo.dynamicData.rentalAdvance.keyword'].value:params['default']",
                    "params": {
                        "default": ""
                    }
                }
            }
        },
        "query": {
            "bool": {
                "must": [
                    {
                        "bool": {
                            "should": [
                                {
                                    "term": {
                                        "dms.resellerInfo.additionalFields.channelId.keyword": "<:channel:>"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.additionalFields.channelId.keyword": {
                                            "value": "<:channel:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.additionalFields.circle.keyword": "<-:circle:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.additionalFields.circle.keyword": {
                                            "value": "<:circle:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.additionalFields.region.keyword": "<-:region:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.additionalFields.region.keyword": {
                                            "value": "<:region:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.additionalFields.cluster.keyword": "<-:cluster:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.additionalFields.cluster.keyword": {
                                            "value": "<:cluster:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.additionalFields.territory.keyword": "<-:territory:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.additionalFields.territory.keyword": {
                                            "value": "<:territory:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.reseller.parentResellerId.keyword": "<-:partner_code_dh:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.reseller.parentResellerId.keyword": {
                                            "value": "<:partner_code_dh:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.reseller.status.keyword": "<-:status:->"
                                    }
                                },
                                {
                                    "wildcard": {
                                        "dms.resellerInfo.reseller.status.keyword": {
                                            "value": "<:status:>"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "bool": {
                            "should": [
                                {
                                    "terms": {
                                        "dms.resellerInfo.reseller.resellerTypeId.keyword": [
                                            "RET",
                                            "GPCF"
                                        ]
                                    }
                                }
                            ]
                        }
                    }
                ]
            }
        }
    }
}
    """

    @Autowired
    private RestHighLevelClient restHighLevelClient

    @Autowired
    ObjectMapper objectMapper

    // Define the order of columns for the report
    private final List<String> columnOrder = [
        "POS_CODE",
        "POS_NAME",
        "ADDRESS",
        "OWNER_NAME",
        "OWNER_CONTACT_NO",
        "CONTACT_PERSON",
        "CONTACT_PERSON_MOBILE_NO",
        "FAX",
        "EMAIL",
        "REGISTRATION_DATE",
        "DEACTIVATION_DATE",
        "COMMISSION_PAYMENT_MODE",
        "COMMISSION_ERS_MSISDN",
        "POS_GEO_CLASS",
        "POS_CATEGORY",
        "POS_VALUE_CLASS",
        "POS_TYPE",
        "SERVICE_TYPE",
        "GPDC",
        "CIRCLE",
        "REGION",
        "CLUSTER",
        "TERRITORY",
        "ROUTE_CODE",
        "ROUTE",
        "ROUTE_FREQUENCY",
        "DISTRICT",
        "THANA",
        "THANA_UNIQUE_CODE",
        "THANA_TYPE",
        "PARTNER_CODE_SE",
        "PARTNER_NAME_SE",
        "SE_ERS_MSISDN",
        "SE_STATUS",
        "SE_SUPERVISOR_CODE",
        "SE_SUPERVISOR_NAME",
        "BANK",
        "BRANCH",
        "ACCOUNT_NO",
        "RETAILER_STATUS",
        "TELCO_STATUS",
        "ERS_STATUS",
        "MFS_STATUS",
        "SC_STATUS",
        "STP",
        "DRC",
        "PARTNER_CODE_DH",
        "PARTNER_NAME_DH",
        "DISTRIBUTOR_MSISDN",
        "ADMIN_THANA",
        "RTR_LEGACY_CODE",
        "ERS_NO",
        "MFS_NO",
        "BIOSCANNER_TAB_IMEI_NO",
        "SCANNER_NUMBER_TAB_SIM_NO",
        "CHANNEL",
        "TELCO_ONBOARD_DATE",
        "TELCO_DEBOARD_DATE",
        "SC_ONBOARD_DATE",
        "SC_DEBOARD_DATE",
        "ERS_ONBOARD_DATE",
        "ERS_DEBOARD_DATE",
        "MFS_ONBOARD_DATE",
        "MFS_DEBOARD_DATE",
        "LATITUDE",
        "LONGITUDE",
        "TIN_NUMBER",
        "TRADE_LICENSE_NUMBER",
        "VAT_REGISTRATION_NUMBER",
        "SHOP_SIZE",
        "WEEKLY_HOLIDAY",
        "SPACE_RENTAL_AGREEMENT_END_DATE",
        "LANDOWNER_NAME",
        "LANDOWNER_CONTACT_NUMBER",
        "MONTHLY_RENT",
        "RENTAL_ADVANCE"
    ]

    @Override
    long getRowCount(ReportRequest reportRequest) {
        // Get the raw request map which might contain additional filters
        def rawRequest = reportRequest.getRawRequest()
        // Safely get the partner_code_rtr value from the raw request
        def partnerCodeRtrObj = rawRequest?.get("partner_code_rtr")
        CountResponse countResponse
        // Check if partner_code_rtr is provided, is a String, and is not blank
        // Yes, the check ensures partnerCodeRtrObj is a String and is not null, empty, or blank (whitespace only).
        // Using isBlank() for clarity (requires Java 11+). The original check was also correct.
        if (partnerCodeRtrObj instanceof String && !((String) partnerCodeRtrObj).trim().isEmpty() && !((String) partnerCodeRtrObj).equals("ALL")) {
            String partnerCodeRtr = (String) partnerCodeRtrObj
            log.info("COUNT - Found non-blank partner_code_rtr: '{}'. Using queryWithRetailerCode.", partnerCodeRtr)
            countResponse = executeElasticsearchQueryForCount(reportRequest, objectMapper, restHighLevelClient, queryWithRetailerCode)
        } else {
            log.info("COUNT - partner_code_rtr is ALL or null or blank. Using queryWithoutRetailerCode.")
	    countResponse = executeElasticsearchQueryForCount(reportRequest, objectMapper, restHighLevelClient, queryWithoutRetailerCode)
        }

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
        Set<SearchResponse> searchResponses
        // Get the raw request map which might contain additional filters
        def rawRequest = reportRequest.getRawRequest()
        // Safely get the partner_code_rtr value from the raw request
        def partnerCodeRtrObj = rawRequest?.get("partner_code_rtr")

        // Check if partner_code_rtr is provided, is a String, and is not blank
        // Yes, the check ensures partnerCodeRtrObj is a String and is not null, empty, or blank (whitespace only).
        // Using isBlank() for clarity (requires Java 11+). The original check was also correct.
        if (partnerCodeRtrObj instanceof String && !((String) partnerCodeRtrObj).trim().isEmpty() && !((String) partnerCodeRtrObj).equals("ALL")) {
            String partnerCodeRtr = (String) partnerCodeRtrObj
            log.info("Found non-blank partner_code_rtr: '{}'. Using queryWithRetailerCode.", partnerCodeRtr)
            searchResponses = executeElasticSearchQuery(reportRequest, objectMapper, restHighLevelClient, queryWithRetailerCode, scrollSize)
        } else {
            log.info("partner_code_rtr is ALL or null or blank. Using queryWithoutRetailerCode.")
            searchResponses = executeElasticSearchQuery(reportRequest, objectMapper, restHighLevelClient, queryWithoutRetailerCode, scrollSize)
        }

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
        log.info("Processing search hits for RET Profile Report")
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
        def totalRecordCount = resultList.size()
        reportResponse.setTotalRecordCount(totalRecordCount)

        return reportResponse
    }
}
