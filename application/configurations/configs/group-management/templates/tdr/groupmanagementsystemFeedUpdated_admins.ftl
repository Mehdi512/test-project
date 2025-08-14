<#compress>
"resultcode": "${response.getResultCode()!400}",
"resultMessage": "${response.getResultMessage()!""}"
<#if response.getResultCode() == 0>,
	"routeCode": "${response.dataFeederMap.groupDataFeeder.code!""}",
	"routeName": "${response.dataFeederMap.groupDataFeeder.name!""}",
        "routeFrequency": "${response.dataFeederMap.groupDataFeeder.groupData.daysToVisit!""}"
	<#if (response.dataFeederMap.RETURN.admins)?? && response.dataFeederMap.RETURN.getAdmins()??>,
	"admins": [
	<#list response.dataFeederMap.RETURN.getAdmins() as admin>
				{
				"userId": "${admin.getUserId()!""}"
				} 
		<#if admin_has_next>, </#if>
	</#list>
	]
	<#else>
	</#if>
</#if>
</#compress>