<#compress>
"resultcode": "${response.getResultCode()!400}",
"resultMessage": "${response.getResultMessage()!""}"
<#if response.getResultCode() == 0>,
	"routeCode": "N/A",
	"routeName": "N/A",
        "routeFrequency": "N/A"
      <#if (response.dataFeederMap.membersDataFeeder)??>,
            "members": [
               <#list response.dataFeederMap.membersDataFeeder as member>
               {
                  "userId": "${member.getUserId()!""}"
               }
                  <#if member_has_next>, </#if>
               </#list>
         ]
      <#elseif (response.dataFeederMap.adminsDataFeeder)??>,
            "admins": [
               <#list response.dataFeederMap.adminsDataFeeder as admin>
               {
                  "userId": "${admin.getUserId()!""}"
               }
                  <#if admin_has_next>, </#if>
               </#list>
         ]      
      </#if>
</#if>
</#compress>