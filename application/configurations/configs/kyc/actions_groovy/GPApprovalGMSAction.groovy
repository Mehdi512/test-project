import com.fasterxml.jackson.databind.ObjectMapper
import com.seamless.common.ExtendedProperties
import com.seamless.ers.kyc.client.constants.KycConstants
import com.seamless.ers.kyc.client.model.*
import com.seamless.kyc.config.KycSpringContext
import com.seamless.kyc.interfaces.ActionEngineInterface
import com.seamless.kyc.repository.CustomerV2Repository
import com.seamless.kyc.repository.impl.CustomerV2RepositoryImpl
import com.seamless.kyc.utils.ExpressionUtils
import com.seamless.kyc.utils.ObjectToJSONUtil
import com.seamless.kyc.utils.RestTemplateUtil
import com.seamless.one.groupmanagement.api.model.GroupModel
import com.seamless.one.groupmanagement.api.model.GroupsResponseModel
import freemarker.template.Template
import freemarker.template.TemplateException
import org.apache.http.HttpStatus
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.http.ResponseEntity
import org.springframework.util.CollectionUtils
import org.springframework.web.client.HttpClientErrorException
import org.springframework.web.client.HttpServerErrorException
import org.springframework.web.client.RestTemplate
import com.seamless.common.config.ERSModuleConfiguration
import com.seamless.kyc.config.DataSourceConfig
import static com.seamless.ers.kyc.client.constants.KycConstants.*
import static com.seamless.kyc.utils.CommonUtils.localizeMessage
import org.springframework.beans.factory.annotation.Autowired

class GPApprovalGMSAction implements ActionEngineInterface {
    private static final Logger log = LoggerFactory.getLogger(GPApprovalGMSAction)

    private ExtendedProperties extendedProperties
    private String actionName
    private CustomerV2Repository customerV2Repository
    private ObjectMapper objectMapper

    @Autowired
    private ERSModuleConfiguration configuration

    @Autowired
    private DataSourceConfig dataSourceConfig

    GPApprovalGMSAction(){

    }

    @Override
    void processRequest(KycTransaction kycTransaction) throws IOException, TemplateException {
        def failedActions = [] as Set<String>
        def stageInfo = new StageInfo(
                timeStamp: new Date(),
                actionName: actionName,
                status: false
        )


        this.extendedProperties = initializeProperties()

        kycTransaction.transactionLifeCycle.lifeCycleStages.add(stageInfo)
        kycTransaction.baseResponse.with {
            resultCode = KYCResultCodes.ACTION_FAILED_AT_KYC.resultCode
            resultMessage = localizeMessage(KYCResultCodes.ACTION_FAILED_AT_KYC.resultDescription)
        }

        if (kycTransaction.extraFields.containsKey(KycConstants.ACTIONS_FAILED)) {
            failedActions = kycTransaction.extraFields[KycConstants.ACTIONS_FAILED] as Set<String>
            failedActions.add(actionName)
            kycTransaction.extraFields[KycConstants.ACTIONS_FAILED] = failedActions
        } else {
            failedActions.add(actionName)
            kycTransaction.extraFields[KycConstants.ACTIONS_FAILED] = failedActions
        }

        Template template = ExpressionUtils.getTemplate(actionName, KycConstants.INCLUDE_EXPRESSION, extendedProperties)
        if (template) {
            boolean criteriaMatched = true
            try {
                criteriaMatched = ExpressionUtils.getValue(kycTransaction, template)
            } catch (Exception e) {
                log.info("Got some exception while parsing template: ${e.message}")
                return
            }

            if (!criteriaMatched) {
                handleNonMatchingCriteria(failedActions, stageInfo, kycTransaction)
                return
            }
        }

        if (!kycTransaction.customer.customerType) {
            log.info("CustomerType not found for customer Id ${kycTransaction.customer.customerId} Operation: ${kycTransaction.operationType}")
            return
        }

        processGMSApproval(kycTransaction, failedActions, stageInfo)
    }

    private void processGMSApproval(KycTransaction kycTransaction, Set<String> failedActions, StageInfo stageInfo) {
        Customer previousCustomerDto = kycTransaction.customer.clone() as Customer
        try {
            customerV2Repository = KycSpringContext.getBean(CustomerV2RepositoryImpl)

            String url = extendedProperties.getProperty(KycConstants.URL) as String
            if (!url) return

            def queryParams = [
                    userId: kycTransaction.customer.customerType,
                    operationCode: kycTransaction.operationType
            ]

            def approvals = [] as List<String>
            processGMSRequest(kycTransaction, url, queryParams, approvals, stageInfo, failedActions, previousCustomerDto)

        } catch (Exception exc) {
            handleGMSError(kycTransaction, exc)
        }
    }

    private void processGMSRequest(KycTransaction kycTransaction, String url, Map queryParams,
                                   List<String> approvals, StageInfo stageInfo,
                                   Set<String> failedActions, Customer previousCustomerDto) {
        def headers = new HttpHeaders().tap {
            contentType = APPLICATION_JSON
            kycTransaction.header.each { k, v -> set(k, v) }
        }

        def request = new HttpEntity<Void>(headers)
        def gmsApiInfo = [:]
        stageInfo.apiInfo["Call to GMS to fetch the group with user id"] = gmsApiInfo

        try {
            url = url + RestTemplateUtil.setQueryParams(queryParams)
            handleGMSResponse(kycTransaction, url, request, gmsApiInfo, approvals, failedActions,
                    stageInfo, previousCustomerDto)
        } catch (HttpServerErrorException | HttpClientErrorException e) {
            handleGMSException(e, kycTransaction, approvals, gmsApiInfo, previousCustomerDto)
        }
    }

    private void updateCustomer(Customer previousCustomerDto, Customer currentCustomerDto) {
        if (!previousCustomerDto) {
            log.info("previousCustomerDto found null")
            return
        }

        def customer = customerV2Repository.findByCustomerId(previousCustomerDto.customerId)
        if (customer) {
            BeanUtils.copyProperties(previousCustomerDto, customer)
            customer.with {
                endDate = new Date()
                kycStatus = KYC_STATUS.DELETED.toString()
            }
            customerV2Repository.index(customer, true)

            currentCustomerDto.lastModifiedDate = new Date()
            customerV2Repository.index(currentCustomerDto, false)
        }
    }
    private void handleNonMatchingCriteria(Set<String> failedActions, StageInfo stageInfo, KycTransaction kycTransaction) {
        failedActions.removeIf { it == actionName }
        stageInfo.status = true

        if (failedActions.empty) {
            kycTransaction.extraFields.remove(KycConstants.ACTIONS_FAILED)
        } else {
            kycTransaction.extraFields[KycConstants.ACTIONS_FAILED] = failedActions
        }

        kycTransaction.baseResponse.with {
            resultCode = KYCResultCodes.SUCCESS.resultCode
            resultMessage = localizeMessage(KYCResultCodes.SUCCESS.resultDescription)
        }

        log.info("criteria does not match for customer Id ${kycTransaction.customer.customerId}")
    }

    private void handleGMSResponse(KycTransaction kycTransaction, String url, HttpEntity<Void> request,
                                   Map gmsApiInfo, List<String> approvals, Set<String> failedActions,
                                   StageInfo stageInfo, Customer previousCustomerDto) {
        def restTemplate = KycSpringContext.getBean(RestTemplate)
        def objectMapper = KycSpringContext.getBean(ObjectMapper)

        log.info("GMS url ${url}")
        gmsApiInfo[URL] = url
        gmsApiInfo[REQUEST] = request

        ResponseEntity<Object> forEntity = restTemplate.exchange(url, HttpMethod.GET, request, Object)
        gmsApiInfo[RESPONSE] = forEntity

        if (forEntity?.statusCode?.value() != HttpStatus.SC_OK) {
            kycTransaction.baseResponse.with {
                resultCode = KYCResultCodes.FETCH_GROUPS_FROM_GMS_ACTION_FAILED.resultCode
                resultMessage = localizeMessage(KYCResultCodes.FETCH_GROUPS_FROM_GMS_ACTION_FAILED.resultDescription)
            }
            return
        }

        def groupsResponseModel = objectMapper.readValue(
                objectMapper.writeValueAsString(forEntity.body),
                GroupsResponseModel
        )

        log.info("response from GMS is ${ObjectToJSONUtil.toString(groupsResponseModel)}")

        if (groupsResponseModel?.resultCode == 0) {
            log.info("GMS called is successful for user id ${kycTransaction.user.userId}, " +
                    "resellerId ${kycTransaction.user.resellerId} and for operation code ${kycTransaction.operationType}")

            groupsResponseModel.groups?.each { GroupModel groupModel ->
                approvals.add(groupModel.name)
            }

            log.info("Next level approval list ${approvals}")

            if (approvals.empty) {
                log.info("No next level approvals are found")
            } else {
                kycTransaction.customer.with {
                    approvalCount++
                    nextLevelApprovals = approvals
                }
            }

            updateCustomer(previousCustomerDto, kycTransaction.customer)

            kycTransaction.baseResponse.with {
                resultCode = KYCResultCodes.SUCCESS.resultCode
                resultMessage = localizeMessage(KYCResultCodes.SUCCESS.resultDescription)
            }

            failedActions.removeIf { it == actionName }
            stageInfo.status = true

            if (CollectionUtils.isEmpty(failedActions)) {
                kycTransaction.extraFields.remove(KycConstants.ACTIONS_FAILED)
            } else {
                kycTransaction.extraFields[KycConstants.ACTIONS_FAILED] = failedActions
            }
        } else {
            kycTransaction.baseResponse.with {
                resultCode = KYCResultCodes.FETCH_GROUPS_FROM_GMS_ACTION_FAILED.resultCode
                resultMessage = localizeMessage(KYCResultCodes.FETCH_GROUPS_FROM_GMS_ACTION_FAILED.resultDescription)
            }
        }
    }

    private void handleGMSException(Exception e, KycTransaction kycTransaction,
                                    List<String> approvals, Map gmsApiInfo, Customer previousCustomerDto) {
        kycTransaction.baseResponse.with {
            resultCode = KYCResultCodes.FETCH_GROUPS_FROM_GMS_ACTION_FAILED.resultCode
            resultMessage = localizeMessage(KYCResultCodes.FETCH_GROUPS_FROM_GMS_ACTION_FAILED.resultDescription)
        }

        log.error("Error while fetching findTargetGroup. Error: ${e.message}", e)
        gmsApiInfo[RESPONSE] = e

        if (e instanceof HttpClientErrorException && e.statusCode.value() == HttpStatus.SC_NOT_FOUND) {
            log.info("No default group found as there is no response from GMS")
            log.info("NextLevelApprovals group will be remain empty")
            kycTransaction.customer.nextLevelApprovals = null
        } else {
            log.info("Assigning default group as there is no response from GMS")
            def defaultGroup = extendedProperties.getProperty(KycConstants.DEFAULTAPPROVALGROUP)
            approvals.add(defaultGroup)
            log.info("Added default group ${approvals}")

            kycTransaction.customer.with {
                approvalCount++
                nextLevelApprovals = approvals
            }
        }

        updateCustomer(previousCustomerDto, kycTransaction.customer)
    }

    private void handleGMSError(KycTransaction kycTransaction, Exception exc) {
        kycTransaction.baseResponse.with {
            resultCode = KYCResultCodes.FETCH_GROUPS_FROM_GMS_ACTION_FAILED.resultCode
            resultMessage = localizeMessage(KYCResultCodes.FETCH_GROUPS_FROM_GMS_ACTION_FAILED.resultDescription)
        }
        log.error("Error while connecting to GMS: ${exc.message}")
    }

    private ExtendedProperties initializeProperties() {
        def props = configuration.getModuleProperties("businessactions.").getSubProperties("GPApprovalGMSAction.")
        actionName = props.get("className")
        objectMapper = dataSourceConfig.objectMapper()
        return props
    }
} 