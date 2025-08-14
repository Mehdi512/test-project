{
<#compress>
  "batchId": "${request.batchId}",
  "importType": "${request.importType}",
  "contractUpdateModels": [
   <#list request.requestObjectsList as contractModel>
    {
      "recordId": "${contractModel?counter}",
      "itemCode": "${contractModel.itemCode!''}",
      "validFromDate": "<#if contractModel.validFromDate?? && contractModel.validFromDate?has_content>${contractModel.validFromDate?date('dd\\/MM\\/yyyy')?string('yyyy-MM-dd')} 00:00:00<#else></#if>",
      "regionsInput": {
        "CHANNEL": "${contractModel.CHANNEL!''}",
        "NATIONAL": "${contractModel.NATIONAL!''}",
        "CIRCLE": "${contractModel.CIRCLE!''}",
        "REGION": "${contractModel.REGION!''}",
        "CLUSTER": "${contractModel.CLUSTER!''}",
        "TERRITORY": "${contractModel.TERRITORY!''}"
      },
      "discountsMap": {
        "Primary": "${contractModel.Primary!''}",
        "Secondary": "${contractModel.Secondary!''}"
      }
    }<#if contractModel?has_next>,</#if>
    </#list>
  ]
</#compress>
}