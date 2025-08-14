{
    <#compress>
        <#list request.requestObjectsList as row>
            "principalId": {
                "id": "${row.resellerId}",
                "type": "RESELLERID"
            },
            "principalResellerType": "${row.resellerType}",
            "toBeParentPrincipalId": "${row.toBeParent}",
            "routeAdmin": "${row.toBeRouteAdmin}",
            "routeCode": "${row.toBeRouteCode}",
            "toBeCircleCode": "${row.toBeCircleCode}",
            "toBeRegionCode": "${row.toBeRegionCode}",
            "toBeClusterCode": "${row.toBeClusterCode}",
            "toBeTerritoryCode": "${row.toBeTerritoryCode}",
            "toBeThanaCode": "${row.toBeThanaCode}",
            "extraParams": {
                "parameters": {
                  "batchId": "${request.batchId}",
                  "importType": "${request.importType}"
                }
              }
        </#list>
    </#compress>
}