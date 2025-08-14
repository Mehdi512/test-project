{
<#compress>
    "batchId": "${request.batchId}",
    "importType": "${request.importType}",
    <#if request.name??>
        "name": "${request.name}",
    </#if>
    "resellers": [
    <#list request.requestObjectsList as resellerList>
        {
        "recordId": ${resellerList?counter},
        "address": {
        <#list resellerList.address?keys as key>
            <#if (resellerList.address[key]?? && resellerList.address[key] != "")>
                "${key}" : "${(resellerList.address[key])}"<#if key_has_next>,</#if>
            </#if>
        </#list>
        },
        "extraParams": {
        "parameters": {
        <#list resellerList.extraParams?keys as key>
            <#if (resellerList.extraParams[key]?? && resellerList.extraParams[key] != "")>
                "${key}" : "${(resellerList.extraParams[key])}"<#if key_has_next>,</#if>
            </#if>
        </#list>
        }
        },
        "users": [{
        <#list resellerList.user?keys as key>
            <#if (resellerList.user[key]?? && resellerList.user[key] != "" )>
                "${key}" : "${(resellerList.user[key])}"<#if key_has_next>,</#if>
            </#if>
        </#list>,
        "fields": {
            "parameters": {
                "enableOtpValidation": "true",
                "enablePasswordValidation": "true"
            }
        }
        }],
        <#list resellerList.fields?keys as key>
            <#if (resellerList.fields[key]?? && resellerList.fields[key] != "")>
                "${key}" : "${(resellerList.fields[key])}"<#if key_has_next>,</#if>
            </#if>
        </#list>
        }<#if resellerList_has_next>,</#if>
    </#list>
    ]
</#compress>
}