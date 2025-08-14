{
<#compress>
    "quotaRules": [
     <#list request.requestObjectsList as stocks>
     {
            <#list stocks?keys as key>
                 <#assign value = stocks[key]>
                 <#if (key?starts_with("date_"))>
                    <#assign parsedDate = value?replace("\\/","/")?datetime("dd/MM/yyyy HH:mm:ss")>
                        "${key?remove_beginning("date_")}" : "${(parsedDate?string("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))}"<#sep>,
                 <#else>
                    "${key}" : "${(value)!''}"<#sep>,
                 </#if>
            </#list>
     }
     <#sep>,</#list>
   ],
    "batchId": "${request.batchId}",
    "importType": "${request.importType}",
    "extraFields":{
         "parameters":{
             "FORCE_UPDATE":${request.forceUpdate}
         }
    }
</#compress>
}