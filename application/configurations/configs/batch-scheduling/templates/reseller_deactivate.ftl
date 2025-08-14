{
<#compress>
    "principalId": {
        "id": "operator",
        "type": "RESELLERID"
    },
    "operationType": "DEACTIVATE",
    "channel": "PORTAL",
    "clientId": "operator",
    "prepareOnly": false,
    "prepareRequired": false,
    "referredChainErsReference": "",
    "pendingTimeout": 600000,
    "customParameters": {
        "globalReason": "Deactivating users"
    },
    "targetPrincipalType": "RESELLERID",
    "targetResellers": {
        <#list request.requestObjectsList as reseller>
            "${reseller.fields["resellerId"]}": "${reseller.fields["reason"]}"<#sep>,
        </#list>
    }
</#compress>
}