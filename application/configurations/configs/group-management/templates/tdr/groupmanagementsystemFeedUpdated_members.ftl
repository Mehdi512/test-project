<#compress>
"resultcode": "${response.getResultCode()!400}",
"resultMessage": "${response.getResultMessage()!""}"
<#if response.getResultCode() == 0>,
		"routeCode": "${response.dataFeederMap.groupDataFeeder.code!""}",
		"routeName": "${response.dataFeederMap.groupDataFeeder.name!""}",
                "routeFrequency": "${response.dataFeederMap.groupDataFeeder.groupData.daysToVisit!""}"
		<#if (response.dataFeederMap.RETURN.members)?? && (response.dataFeederMap.RETURN.getMembers())?? >,
		"members": [
				<#list response.dataFeederMap.RETURN.getMembers() as member>
					{
						"userId": "${member.getUserId()!""}"
					}
						<#if member_has_next>, </#if>
				</#list>
		]
		<#else>
		</#if>
</#if>
</#compress>