{
<#compress>
    "batchId": "${request.batchId}",
    "importType": "${request.importType}",
    "resellers": [
    <#list request.requestObjectsList as resellerList>
        {
        "recordId": ${resellerList?counter},
        "storageType": "APPEND_DYNAMIC_FIELD",
        "extraParams": {
        "parameters": {
        <#list resellerList.extraParams?keys as key>
            "${key}" : "${resellerList.extraParams[key]}"<#if key_has_next>,</#if>
        </#list>
        }
        },

        "dealerPrincipal" : {
        "id": "${resellerList['resellerId']}",
        "type": "RESELLERID"
        }
        }<#if resellerList_has_next>,</#if>
    </#list>
    ]
</#compress>
}