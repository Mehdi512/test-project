{
<#compress>
    "batchId": "${request.batchId}",
    "importType": "${request.importType}",
    "resellers": [
    <#list request.requestObjectsList as resellerList>
    {
        "recordId": ${resellerList?counter},
        "dealerPrincipal" : {
            "id": "${resellerList.fields['resellerId']}",
            "type": "RESELLERID"
        },
        "dealerData" : {
            "resellerId": "${resellerList.fields['resellerId']}",
            "users": [
                {
                    "userId": "${resellerList.user.userId}",
                    "password": "${resellerList.user.password}"
                }
            ]
        }
    }<#if resellerList_has_next>,</#if>
    </#list>
    ]
</#compress>
}
