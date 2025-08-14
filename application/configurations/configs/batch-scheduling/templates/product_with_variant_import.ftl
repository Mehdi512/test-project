{
    <#compress>
    "batchId": "${request.batchId}",
    "importType": "${request.importType}",
    "products": [
        <#list request.requestObjectsList as listItem>
            { <@transformObj listItem /> }
            <#sep>,
        </#list>
    ]

    <#macro transformObj listItem>
        <#list listItem?keys as key>
            <#assign value = listItem[key]>
            <#if (value?is_hash_ex)>
                <#if (key?starts_with("list_"))>
                    <#assign listName = key?remove_beginning("list_")>
                    <#if key == "list_data">
                        <#assign nonEmptyValues = value?values?filter(v -> v.dataValue?has_content)>
                        <#if nonEmptyValues?size gt 0>
                            "${listName}" : [
                                <#list nonEmptyValues as listValues>
                                    { <@transformObj listValues/> }
                                    <#sep>,
                                </#list>
                            ]
                        </#if>
                    <#else>
                        "${listName}" : [
                            <#list value?values as listValues>
                                { <@transformObj listValues/> }
                                <#sep>,
                            </#list>
                        ]
                    </#if>
                <#else>
                    "${key}" : { <@transformObj value/> }
                </#if>
            <#elseif (key?starts_with("date_"))>
                "${key?remove_beginning("date_")}" : "${(value?datetime("dd\\/MM\\/yyyy")?string("yyyy-MM-dd"))!''}"
            <#else>
                "${key}" : "${(value)!''}"
            </#if>
            <#sep>,
        </#list>
    </#macro>
    </#compress>
}