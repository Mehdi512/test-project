{
<#compress>
    "params": {
        "batchId": "${request.batchId}"
    },
    "requests": [
     <#list request.requestObjectsList as row>
            <#-- Split the data for the Circle -->
         <#assign circleData = row.circle?split(":")>
            <#-- Split the data for the Region -->
         <#assign regionData = row.region?split(":")>
             <#-- Split the data for the Cluster -->
         <#assign clusterData = row.cluster?split(":")>
            <#-- Split the data for the Territory -->
         <#assign territoryData = row.territory?split(":")>
            <#-- Split the data for the Thana -->
         <#assign thanaData = row.thana?split(":")>
         {
             "regionName": "${circleData[1]}",
             "id": "${circleData[0]}",
             "level": "2",
             "parentRegionName": "Bangladesh Market",
             "data": "",
                 "subRegions": [
                     {
                         "regionName": "${regionData[1]}",
                         "id": "${regionData[0]}",
                         "data": "",
                         "subRegions": [
                             {
                             "regionName": "${clusterData[1]}",
                             "id": "${clusterData[0]}",
                             "data": "",
                             "subRegions": [
                                 {
                                     "regionName": "${territoryData[1]}",
                                     "id": "${territoryData[0]}",
                                     "data": "",
                                     "subRegions": [
                                         {
                                             "regionName": "${thanaData[1]}",
                                             "id": "${thanaData[0]}",
                                             "data": ""
                                         }
                                     ]
                                 }
                             ]
                         }
                     ]
                 }
             ]
         }
     </#list>
    ]
</#compress>
}