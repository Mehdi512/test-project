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
import java.util.Collections
import com.seamless.ers.interfaces.ersifcommon.dto.UserStatus;

import static com.seamless.ers.kyc.client.constants.KycConstants.PREVIOUS_CUSTOMER_ID
import static com.seamless.ers.kyc.client.constants.KycConstants.REQUEST
import static com.seamless.ers.kyc.client.constants.KycConstants.RESPONSE
import static com.seamless.ers.kyc.client.constants.KycConstants.URL
import static com.seamless.kyc.utils.CommonUtils.localizeMessage
import static com.seamless.kyc.enums.PasswordMaskSubstitutionTypes.*

class NonGpUserAction implements ActionEngineInterface {
    private static final Logger log = Logger.getLogger(NonGpUserAction.class)

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
        def props = configuration.getModuleProperties("businessactions.").getSubProperties("NonGpUserAction.")
        actionName = props.get("className")
        objectMapper = dataSourceConfig.objectMapper()
        return props
    }

    private void handleActionExecution(KycTransaction kycTransaction, ExtendedProperties props, StageInfo stageInfo) {
        updateFailedActionsList(kycTransaction)

        log.info("in handleActionExecution")
        log.info("KYC transaction:: ${kycTransaction}")
        if (shouldSkipExecution(kycTransaction, props)) {
            log.info(" In Returning ........")
            handleSuccessfulExclusion(kycTransaction, stageInfo)

            return
        }

        if (StringUtils.isEmpty(props.getProperty(KycConstants.URL))) {
            log.info("Skipping DMS. No DMS base url found")
            return
        }
        log.info("calling dms now ........")
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
        log.info("template  "+template)
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
        //def body = buildRequestBody(kycTransaction, parentResellerId)
        //return new HttpEntity<>(body, headers)

        // Create a proper Map for JSON request
        def requestBody = [
                resellerIdType: "RESELLERID",
                resellerId: kycTransaction.customer.getExtraFields()?.partnerCode ?: "",
                users: objectMapper.readValue(buildUserData(kycTransaction.customer, kycTransaction.customer.extraFields), List.class)
        ]

        return new HttpEntity<>(requestBody, headers)
    }

    private HttpHeaders buildHeaders(KycTransaction kycTransaction) {
        def headers = new HttpHeaders()
        headers.setContentType(MediaType.APPLICATION_JSON)
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON))


        kycTransaction.header.each { key, value ->
            headers.add(key, value)
        }
        return headers
    }

    private String buildUserData(Customer customer,Map<String, String> extraFields) {
        def userData = new UserData().with {
            password = extraFields.get("motte_de_passe")
            roleId = customer.roleId
            email = customer.email
            userStatus = customer.customerStatus
            userId = customer.customerId
            name = customer.firstName
            phone = customer.msisdn

            // Create ERSHashtableParameter for fields
            def parameters = new ERSHashtableParameter()

            // Add basic customer fields
            parameters.put("roleId", customer.roleId?.toString())
            parameters.put("email", customer.email?.toString())
            parameters.put("msisdn", customer.msisdn?.toString())
            parameters.put("dateOfBirth", customer.dateOfBirth?.toString())
            parameters.put("customerType", customer.customerType?.toString())
            parameters.put("nationalIdNumber", customer.nationalIdNumber?.toString())
            parameters.put("customerStatus", customer.customerStatus?.toString())
            parameters.put("address", customer.address?.toString())
            parameters.put("parentResellerId", customer.parentResellerId?.toString())

            customer.extraFields.each { key, value ->
                parameters.put(key, value?.toString())
            }
            fields = parameters

            
            return it
        }
        return objectMapper.writeValueAsString([userData])
    }

   private ResponseEntity<?> sendRequest(String url, HttpEntity<?> requestData) {
       log.info(" requestData ::  ${requestData}")
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
    private String email;
    private String phone;
    private String name;
    private String userId;
    private ERSHashtableParameter fields;
    private UserStatus userStatus;

    String getPassword() {
        return password
    }

    void setPassword(String password) {
        this.password = password
    }

    String getRoleId() {
        return roleId
    }

    void setRoleId(String roleId) {
        this.roleId = roleId
    }

    String getEmail() {
        return email
    }

    void setEmail(String email) {
        this.email = email
    }

    String getPhone() {
        return phone
    }

    void setPhone(String phone) {
        this.phone = phone
    }

    String getName() {
        return name
    }

    void setName(String name) {
        this.name = name
    }

    String getUserId() {
        return userId
    }

    void setUserId(String userId) {
        this.userId = userId
    }

    public ERSHashtableParameter getFields()
    {
        return fields;
    }

    public void setFields(ERSHashtableParameter fields)
    {
        this.fields = fields;
    }

    public UserStatus getUserStatus() {
        return this.userStatus;
    }

    public void setUserStatus(UserStatus userStatus) {
        this.userStatus = userStatus;
    }
}