{
<#compress>
    "batchId": "${request.batchId}",
    "importType": "${request.importType}",
    "externalInventoryList": [
    <#list request.requestObjectsList as inventList>
        {
        <#list inventList.fields?keys as key>
            "${key}" : "${inventList.fields[key]}"<#if key_has_next>,</#if>
        </#list>
        }<#if inventList?has_next>,</#if>
    </#list>
    ]
</#compress>
}