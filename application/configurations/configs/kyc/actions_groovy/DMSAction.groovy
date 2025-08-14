import com.fasterxml.jackson.databind.ObjectMapper
import com.seamless.common.ExtendedProperties
import com.seamless.common.StringUtils
import com.seamless.common.config.ERSModuleConfiguration
import com.seamless.ers.interfaces.ersifcommon.dto.ERSHashtableParameter
import com.seamless.ers.interfaces.ersifcommon.dto.AddressData
import com.seamless.ers.interfaces.ersifcommon.dto.PrincipalId
import com.seamless.ers.interfaces.ersifcommon.dto.resellers.ResellerStatus
import com.seamless.ers.kyc.client.constants.KycConstants
import com.seamless.ers.kyc.client.model.KYCResultCodes
import com.seamless.ers.kyc.client.model.KycTransaction
import com.seamless.ers.kyc.client.model.StageInfo
import com.seamless.kyc.config.DataSourceConfig
import com.seamless.kyc.interfaces.ActionEngineInterface
import com.seamless.kyc.utils.ExpressionUtils
import com.seamless.kyc.utils.ObjectToJSONUtil
import freemarker.template.Template
import freemarker.template.TemplateException
import org.apache.http.HttpStatus
import org.apache.log4j.Logger
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.util.LinkedMultiValueMap
import org.springframework.util.MultiValueMap
import org.springframework.web.client.HttpClientErrorException
import org.springframework.web.client.HttpServerErrorException
import org.springframework.web.client.RestTemplate
import org.springframework.web.client.UnknownHttpStatusCodeException
import com.seamless.ers.kyc.client.model.Customer

import static com.seamless.ers.kyc.client.constants.KycConstants.REQUEST
import static com.seamless.ers.kyc.client.constants.KycConstants.RESPONSE
import static com.seamless.ers.kyc.client.constants.KycConstants.URL
import static com.seamless.kyc.utils.CommonUtils.localizeMessage
import static com.seamless.kyc.enums.PasswordMaskSubstitutionTypes.*

class DMSAction implements ActionEngineInterface {
    private static final Logger log = Logger.getLogger(DMSAction.class)

    @Autowired
    private ERSModuleConfiguration configuration

    @Autowired
    private DataSourceConfig dataSourceConfig

    private String actionName
    private String moduleName
    private ObjectMapper objectMapper
    private List<String> failedActions = []

    @Override
    void processRequest(KycTransaction kycTransaction) {
        StageInfo stageInfo = initializeStageInfo()
        kycTransaction.transactionLifeCycle.lifeCycleStages.add(stageInfo)
        setInitialResponse(kycTransaction)

        try {
            def extendedProperties = initializeProperties()
            handleActionExecution(kycTransaction, extendedProperties, stageInfo)
        } catch (Exception exc) {
            log.error("Error while connecting to DMS: ${exc.message}", exc)
        }
    }

    private StageInfo initializeStageInfo() {
        new StageInfo(
            timeStamp: new Date(),
            actionName: actionName,
            status: false
        )
    }

    private void setInitialResponse(KycTransaction kycTransaction) {
        kycTransaction.baseResponse.with {
            resultCode = KYCResultCodes.ACTION_FAILED_AT_KYC.resultCode
            resultMessage = localizeMessage(KYCResultCodes.ACTION_FAILED_AT_KYC.resultDescription)
        }
    }

    private ExtendedProperties initializeProperties() {
        def props = configuration.getModuleProperties("businessactions.").getSubProperties("DMSAction.")
        actionName = props.get("className")
        objectMapper = dataSourceConfig.objectMapper()
        return props
    }

    private void handleActionExecution(KycTransaction kycTransaction, ExtendedProperties props, StageInfo stageInfo) {
        updateFailedActionsList(kycTransaction)

        if (shouldSkipExecution(kycTransaction, props)) {
            handleSuccessfulExclusion(kycTransaction, stageInfo)
            return
        }

        if (StringUtils.isEmpty(props.getProperty(KycConstants.URL))) {
            log.info("Skipping DMS. No DMS base url found")
            return
        }

        executeDmsRequest(kycTransaction, props, stageInfo)
    }

    private void updateFailedActionsList(KycTransaction kycTransaction) {
        if (kycTransaction.extraFields.containsKey(KycConstants.ACTIONS_FAILED)) {
            failedActions = kycTransaction.extraFields.get(KycConstants.ACTIONS_FAILED) as List<String>
        }
        if (!failedActions.contains(actionName)) {
            failedActions.add(actionName)
        }
        kycTransaction.extraFields[KycConstants.ACTIONS_FAILED] = failedActions
    }

    private boolean shouldSkipExecution(KycTransaction kycTransaction, ExtendedProperties props) {
        def template = ExpressionUtils.getTemplate(actionName, KycConstants.EXCLUDE_EXPRESSION, props)
        if (!template) return false

        try {
            return ExpressionUtils.getValue(kycTransaction, template)
        } catch (Exception e) {
            log.info("Exception while parsing template: ${e.message}")
            return false
        }
    }

    private void executeDmsRequest(KycTransaction kycTransaction, ExtendedProperties props, StageInfo stageInfo) {
        def url = props.getProperty(KycConstants.URL)
        def dmsApiInfo = [:]
        stageInfo.apiInfo["DMS call to fetch group with userId"] = dmsApiInfo
        dmsApiInfo[URL] = url

        try {
            def requestData = buildDmsRequest(kycTransaction, props.getProperty(KycConstants.PARENT_RESELLERID))
            dmsApiInfo[REQUEST] = requestData
            logRequest(kycTransaction, requestData)

            def response = sendRequest(url, requestData)
            dmsApiInfo[RESPONSE] = response

            handleDmsResponse(kycTransaction, response, stageInfo)
            logResponse(kycTransaction, response)
        } catch (HttpServerErrorException | UnknownHttpStatusCodeException e) {
            handleDmsError(kycTransaction, e, dmsApiInfo)
        }
    }

    private HttpEntity<?> buildDmsRequest(KycTransaction kycTransaction, String parentResellerId) {
        def headers = buildHeaders(kycTransaction)
        def body = buildRequestBody(kycTransaction, parentResellerId)
        return new HttpEntity<>(body, headers)
    }

    private HttpHeaders buildHeaders(KycTransaction kycTransaction) {
        def headers = new HttpHeaders()
        headers.contentType = MediaType.MULTIPART_FORM_DATA
        kycTransaction.header.each { key, value ->
            headers.add(key, value)
        }
        return headers
    }

    private MultiValueMap<String, String> buildRequestBody(KycTransaction kycTransaction, String parentResellerId) {
        def body = new LinkedMultiValueMap<String, String>()
        def customer = kycTransaction.customer

        // Basic reseller info
        def bodyMap = [
            resellerType: customer?.customerType ?: "",
            resellerId: customer?.customerId ?: "",
            resellerMSISDN: customer?.msisdn ?: "",
            parentResellerId: customer?.parentResellerId ?: parentResellerId ?: "",
            status: customer?.customerStatus ?: ResellerStatus.Active.toString(),
            JuridicalName: customer?.familyName ?: "",
            name: customer?.firstName ?: "",
            countryCode: customer?.country ?: "",
            language: customer?.preferredLanguage ?: "",
            contractId: customer?.contractId ?: "",
            dateOfBirth:customer?.dateOfBirth ?: "",
            phone:customer?.telNo1 ?: ""
        ]

        bodyMap.each { key, value ->
            body.add(key, value)
        }

        def dynamicData = kycTransaction.customer.dynamicData
        if (dynamicData && dynamicData.size()!=0) {
            // Check and update DOB in dynamicData
            if (!dynamicData.containsKey('dob') || !dynamicData.dob) {
                dynamicData.dob = customer?.dateOfBirth ?: ''
            }
            // Check and update nidNumber in dynamicData
            if (!dynamicData.containsKey('nidNumber') || !dynamicData.nidNumber) {
                dynamicData.nidNumber = customer?.nationalIdNumber ?: ''
            }
            body.add('dynamicData', objectMapper.writeValueAsString(dynamicData))
            // log.info('Added dynamicData to DMS request: {}', dynamicData)
        } else {
            log.debug('No dynamicData defined')
        }

        // Address
        body.add("address", objectMapper.writeValueAsString(buildAddress(customer)))

        // User data
        body.add("users", buildUserData(customer.extraFields))

        // Additional fields
        body.add("additionalFields", buildAdditionalFields(customer))

        return body
    }

    private AddressData buildAddress(Customer customer) {
        new AddressData().with {
            city = customer.city
            country = customer.country
            email = customer.email
            phone = customer.telNo1
            street = customer.street
            zip = customer.zipcode
            return it
        }
    }

    private String buildUserData(Map<String, String> extraFields) {
        def userData = new UserData().with {
            password = extraFields.get("motte_de_passe")
            roleId = extraFields.get("roleId")
            return it
        }
        return objectMapper.writeValueAsString([userData])
    }

    private String buildAdditionalFields(Customer customer) {
        def standardFields = []

        def customFields = customer.extraFields
            .findAll { key, _ ->
                !["roleId", "roleStartDate", "roleExpiryDate", "motte_de_passe"].contains(key)
            }
            .collect { key, value -> [name: key, value: value] }

        return objectMapper.writeValueAsString(standardFields + customFields)
    }

   private ResponseEntity<?> sendRequest(String url, HttpEntity<?> requestData) {
        new RestTemplate().postForEntity(url, requestData, Object.class)
    }

    private void handleDmsResponse(KycTransaction kycTransaction, ResponseEntity<?> response, StageInfo stageInfo) {
        if (!isValidResponse(response)) {
            setFailureResponse(kycTransaction, KYCResultCodes.RESELLER_CREATION_ACTION_FAILED)
            return
        }

        def baseRestResponse = response.body as LinkedHashMap
        if (isDmsSuccess(baseRestResponse)) {
            handleSuccessResponse(kycTransaction, stageInfo)
        } else {
            handleFailureResponse(kycTransaction, baseRestResponse)
        }
    }

    private boolean isValidResponse(ResponseEntity<?> response) {
        response?.statusCode?.value() == HttpStatus.SC_OK
    }

    private boolean isDmsSuccess(LinkedHashMap response) {
        response?.resultCode as Integer == 0
    }

    private void handleSuccessfulExclusion(KycTransaction kycTransaction, StageInfo stageInfo) {
        failedActions.remove(actionName)
        stageInfo.status = true

        if (failedActions.empty) {
            kycTransaction.extraFields.remove(KycConstants.ACTIONS_FAILED)
        } else {
            kycTransaction.extraFields[KycConstants.ACTIONS_FAILED] = failedActions
        }

        setSuccessResponse(kycTransaction)
    }

    private void handleSuccessResponse(KycTransaction kycTransaction, StageInfo stageInfo) {
        failedActions.remove(actionName)
        stageInfo.status = true

        if (failedActions.empty) {
            kycTransaction.extraFields.remove(KycConstants.ACTIONS_FAILED)
        } else {
            kycTransaction.extraFields[KycConstants.ACTIONS_FAILED] = failedActions
        }

        setSuccessResponse(kycTransaction)
    }
    private void handleFailureResponse(KycTransaction kycTransaction, LinkedHashMap response) {
        setFailureResponse(kycTransaction, KYCResultCodes.RESELLER_CREATION_ACTION_FAILED)
        if (response?.resultDescription) {
            kycTransaction.baseResponse.resultMessage = response.resultDescription
        }
    }
    private void handleDmsError(KycTransaction kycTransaction, Exception e, Map dmsApiInfo) {
        dmsApiInfo[RESPONSE] = e
        setFailureResponse(kycTransaction, KYCResultCodes.RESELLER_CREATION_ACTION_FAILED)
        log.error("Error in DMS operation ${kycTransaction.operationType}: ${e.message}", e)
    }
    private void setSuccessResponse(KycTransaction kycTransaction) {
        kycTransaction.baseResponse.with {
            resultCode = KYCResultCodes.SUCCESS.resultCode
            resultMessage = localizeMessage(KYCResultCodes.SUCCESS.resultDescription)
        }
    }
    private void setFailureResponse(KycTransaction kycTransaction, KYCResultCodes resultCodeEnum) {
        kycTransaction.baseResponse.with {
            resultCode = resultCodeEnum.resultCode
            resultMessage = localizeMessage(resultCodeEnum.resultDescription)
        }
    }
    private void logRequest(KycTransaction kycTransaction, requestData) {
        def maskedRequest = ObjectToJSONUtil.toStringWithPasswordMasking(
                requestData,
                PASSWORD_WITH_COLON_QUOTED,
                MOTTE_DE_PASS_NAME_VALUE_PAIR_QUOTED
        )
        log.info("DMS request for operation ${kycTransaction.operationType}: ${maskedRequest}")
    }
    private void logResponse(KycTransaction kycTransaction, response) {
        def maskedResponse = ObjectToJSONUtil.toStringWithPasswordMasking(
                response,
                PASSWORD_WITH_COLON_QUOTED,
                MOTTE_DE_PASS_NAME_VALUE_PAIR_QUOTED
        )
        log.info("DMS response for operation ${kycTransaction.operationType}: ${maskedResponse}")
    }
}

class UserData
{
    private String password;
    private String roleId;
    private ERSHashtableParameter fields;

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }

    public String getRoleId()
    {
        return roleId;
    }

    public void setRoleId(String roleId)
    {
        this.roleId = roleId;
    }

    public ERSHashtableParameter getFields()
    {
        return fields;
    }

    public void setFields(ERSHashtableParameter fields)
    {
        this.fields = fields;
    }
}