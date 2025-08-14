{
<#compress>
    "batchId": "${request.batchId}",
    "importType": "${request.importType}",
    "assetMetaData": [
    <#list request.requestObjectsList as assetMetaDataList>
        {
        "recordId": ${assetMetaDataList?index},
        <#if (assetMetaDataList.id)??>
            "assetId": "${assetMetaDataList.id}",
        </#if>
        "name": "${assetMetaDataList.dmsBankName}",
        "metadata": [
        <#list assetMetaDataList.extraParams?keys as key>
            {
            "key" : "${key}",
            "value" : "${assetMetaDataList.extraParams[key]}"
            } <#if key_has_next>,</#if>
        </#list>
        ],
        "assetType": "BANK",
        "status":"Active"
        }<#if assetMetaDataList_has_next>,</#if>
    </#list>
    ]
</#compress>
}