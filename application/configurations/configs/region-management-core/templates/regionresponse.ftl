<#compress>
    <#if response.class.simpleName == "DataResponse" && response.getData()?? && response.getData()?size gt 0>
        <#assign regionData = response.getData() />
        "data": [
        <#list regionData as data>
            "resultcode": ${data.resultCode!0},
			"resultMessage": "${data.resultMessage!""}"
			"regionId": "${data.regionId!""}",
			"regionType": "${data.regionType!""}",
			"regionName": "${data.regionName!""}",
			"path": "${data.path!""}",
			"data": "${data.data!""}",
			"location": "${data.location!""}",
			"cluster": "${data.cluster!""}",
			"distributor": "${data.distributor!""}",
			"ovaAccounts": "${data.ovaAccounts!""}",
			"ownerUserName": "${data.ownerUserName!""}",
			"ownerLevel": "${response.ownerLevel!""}",<#if data_has_next>,</#if>
        </#list>
        ]
    <#else>
    </#if>
</#compress>

<#compress>
    <#if response.class.simpleName == "RegionResponse">
     "data": "${response.data!""}"
         <#if response.getSubRegions()?? && response.getSubRegions()?size gt 0>
            <#assign regionData = response.getSubRegions() />
            ,
            "subRegions": [
            <#list regionData as data>
                "resultcode": ${data.resultCode!0},
                "resultMessage": "${data.resultMessage!""}"
                "regionId": "${data.regionId!""}",
                "regionType": "${data.regionType!""}",
                "regionName": "${data.regionName!""}",
                "path": "${data.path!""}",
                "data": "${data.data!""}",
                "location": "${data.location!""}",
                "cluster": "${data.cluster!""}",
                "distributor": "${data.distributor!""}",
                "ovaAccounts": "${data.ovaAccounts!""}",
                "ownerUserName": "${data.ownerUserName!""}",
                "ownerLevel": "${response.ownerLevel!""}",<#if data_has_next>,</#if>
            </#list>
            ]
        <#else>
        </#if>
    <#else>
    </#if>
</#compress>

<#compress>
    <#if response.class.simpleName == "RegionTypeResponseV2">
        "regionTypeId": "${response.regionTypeId!""}",
        "regionTypeName": "${response.regionTypeName!""}",
        "level": "${response.level!""}",
        "createDate":
        <#if response.createDate??>
             "${response.createDate?string("yyyy-MM-dd HH:mm:ss")}"
        <#else>""</#if>,
        "updateDate":
        <#if response.updateDate??>
            "${response.updateDate?string("yyyy-MM-dd HH:mm:ss")}"
        <#else>""</#if>
        <#if response.getRegionCategory()??>
        <#assign regionCategory = response.getRegionCategory() />
        ,"regionCategory": {
            "regionCategoryId": "${regionCategory.id!""}",
            "regionCategoryName": "${regionCategory.name!""}",
            "description": "${regionCategory.description!""}",
            "createDate":
            <#if regionCategory.createDate??>
                "${regionCategory.createDate?string("yyyy-MM-dd HH:mm:ss")}"
            <#else>""</#if>,
            "updateDate":
            <#if regionCategory.createDate??>
                 "${regionCategory.updateDate?string("yyyy-MM-dd HH:mm:ss")}"
            <#else>""</#if>,
            "regionCategoryIdentifier": "${regionCategory.identifier!""}"
            }
        <#else>""</#if>
    <#else>
    </#if>
</#compress>

<#compress>
    <#if response.class.simpleName == "RegionResponseV2">
        "regionId": "${response.regionId!""}",
        "id": "${response.id!""}",
        "regionName": "${response.regionName!""}",
        "path": "${response.path!""}",
        "location": "${response.location!""}",
        "cluster": "${response.cluster!""}",
        "distributor": "${response.distributor!""}",
        "ovaAccounts": "${response.ovaAccounts!""}",
        "ownerUserName": "${response.ownerUserName!""}",
        "ownerLevel": "${response.ownerLevel!""}",
        "createdDate": "${response.createdDate?string('yyyy-MM-dd HH:mm:ss')!""}",
        "updatedDate": "${response.updatedDate?string('yyyy-MM-dd HH:mm:ss')!""}",

        "regionType": {
            "regionTypeId": "${response.regionType.regionTypeId!""}",
            "regionTypeName": "${response.regionType.regionTypeName!""}",
            "level": "${response.regionType.level!""}",
            "createDate": "${response.regionType.createDate?string('yyyy-MM-dd HH:mm:ss')!""}",
            "updateDate": "${response.regionType.updateDate?string('yyyy-MM-dd HH:mm:ss')!""}",

            <#if response.getRegionType().getRegionCategory()??>
                <#assign regionCategory = response.getRegionType().getRegionCategory() />
                "regionCategory": {
                    "regionCategoryId": "${regionCategory.id!""}",
                    "regionCategoryName": "${regionCategory.name!""}",
                    "description": "${regionCategory.description!""}",
                    "createDate": "${regionCategory.createDate?string('yyyy-MM-dd HH:mm:ss')!""}",
                    "updateDate": "${regionCategory.updateDate?string('yyyy-MM-dd HH:mm:ss')!""}",
                    "regionCategoryIdentifier": "${regionCategory.identifier!""}"
                }
            <#else>
                "regionCategory": null
            </#if>
        },

        "parent": <#if response.getParent()?? && response.getParent().getRegionType()?? && response.getParent().getRegionType().getRegionCategory()??>
            <#assign parentRegion = response.getParent() />
            <#assign parentRegionType = response.getParent().getRegionType() />
            <#assign parentRegionCategory = response.getParent().getRegionType().getRegionCategory() />
            {
                "regionId": "${parentRegion.regionId!""}",
                "id": "${parentRegion.id!""}",
                "regionName": "${parentRegion.regionName!""}",
                "path": "${parentRegion.path!""}",
                "location": "${parentRegion.location!""}",
                "cluster": "${parentRegion.cluster!""}",
                "distributor": "${parentRegion.distributor!""}",
                "ovaAccounts": "${parentRegion.ovaAccounts!""}",
                "ownerUserName": "${parentRegion.ownerUserName!""}",
                "ownerLevel": "${parentRegion.ownerLevel!""}",
                "createDate": "${parentRegion.createdDate?string('yyyy-MM-dd HH:mm:ss')!""}",
                "updatedDate": "${parentRegion.updatedDate?string('yyyy-MM-dd HH:mm:ss')!""}",

                "regionTypeId": "${parentRegionType.regionTypeId!""}",
                "regionTypeName": "${parentRegionType.regionTypeName!""}",
                "level": "${parentRegionType.level!""}",
                "regionCategoryName": "${parentRegionCategory.name!""}"
            }
        <#else>
            null
        </#if>
    </#if>
</#compress>

<#compress>
    <#if response.class.simpleName == "RegionMappingResponse">
        "masterRegionId": "${response.masterRegionId!""}",
        "slaveRegionIds":
        <#if response.getSlaveRegionIds()??>
        <#assign slaveRegionIds = response.getSlaveRegionIds() />
            [
                <#list slaveRegionIds as data>
                "${data}"<#if data_has_next>,</#if>
                </#list>
            ]
        <#else>""</#if>
    <#else>
    </#if>
</#compress>
