<#setting number_format="0" />
"oms.resultcode":${(response.resultCode)!'N/A'},
<#setting number_format="" />
"oms.resultMessage":"${(response.resultMessage)!'N/A'}",
"oms.headers.clientComment":"${(response.clientComment)!'N/A'}",
"oms.headers.clientReference":"${(response.clientReference)!'N/A'}",
"oms.orderId":"${(response.orderId)!'N/A'}",
"oms.orderType":"${(response.orderType)!'N/A'}",
"oms.paymentMode":"${(response.paymentMode)!'N/A'}",
"oms.paymentAgreement":"${(response.paymentAgreement)!'N/A'}",
"oms.orderStatus":"${(response.orderStatus)!'N/A'}",
"oms.orderStatusName":"${(response.orderStatusName)!'N/A'}",
<#if response.buyer??>
"oms.buyer.id":"${(response.buyer.id)!'N/A'}",
</#if>
<#if response.seller??>
"oms.seller.id":"${(response.seller.id)!'N/A'}",
</#if>
"oms.receivers":[<#list response.receivers as receiver>
{
<#if receiver??>
"id":"${(receiver.id)!'N/A'}"
</#if>
}
<#sep>,
</#list>],
<#if response.invoices??>
"oms.invoices":[<#list response.invoices as invoice>{
"invoice.id":"${(invoice.invoiceId)!'N/A'}",
"invoice.status":"${(invoice.status)!'N/A'}",
"invoice.totalPrice":{
<#if invoice.totalUnitPrice?? >
"amount":"${(invoice.totalUnitPrice.amount)!'N/A'}",
"currency":"${(invoice.totalUnitPrice.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"invoice.totalOfferPrice":{
<#if invoice.totalOfferPrice?? >
"amount":"${(invoice.totalOfferPrice.amount)!'N/A'}",
"currency":"${(invoice.totalOfferPrice.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"invoice.totalTax":{
<#if invoice.totalCalculatedTax?? >
"amount":"${(invoice.totalCalculatedTax.amount)!'N/A'}",
"currency":"${(invoice.totalCalculatedTax.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"invoice.totalDiscount":{
<#if invoice.totalDiscount?? >
"amount":"${(invoice.totalDiscount.amount)!'N/A'}",
"currency":"${(invoice.totalDiscount.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"invoice.totalNetPrice":{
<#if invoice.totalRetailPrice?? >
"amount":"${(invoice.totalRetailPrice.amount)!'N/A'}",
"currency":"${(invoice.totalRetailPrice.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"invoice.totalSenderCommission":{
<#if invoice.totalSenderCommission?? >
"amount":"${(invoice.totalSenderCommission.amount)!'N/A'}",
"currency":"${(invoice.totalSenderCommission.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"invoice.totalReceiverCommission":{
<#if invoice.totalReceiverCommission?? >
"amount":"${(invoice.totalReceiverCommission.amount)!'N/A'}",
"currency":"${(invoice.totalReceiverCommission.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"invoice.invoiceProperties":{
<#if invoice.invoiceProperties??>
<#list invoice.invoiceProperties?keys as key>
"${key!'N/A'}": "${invoice.invoiceProperties[key]!'N/A'}"<#sep>,</#list>
</#if>
},
"invoice.paymentsInfo" : [
<#if invoice.paymentsInfo??>
<#list invoice.paymentsInfo as invoicePaymentInfo>
{
<#if invoicePaymentInfo??>
"paymentMode": "${(invoicePaymentInfo.paymentMode)!'N/A'}",
"amount": "${(invoicePaymentInfo.amount)!'N/A'}",
"paymentAttributes": [
<#if invoicePaymentInfo.paymentAttributes??>
<#list invoicePaymentInfo.paymentAttributes as invoicePaymentInfoAttribute>
{
<#if invoicePaymentInfoAttribute??>
"parameterType" : "${(invoicePaymentInfoAttribute.parameterType)!'N/A'}",
"parameterValue" : "${(invoicePaymentInfoAttribute.parameterValue)!'N/A'}"
</#if>}<#sep>,</#list>
</#if>
]
</#if>}<#sep>,</#list>
</#if>
],
"invoice.invoiceEntries":[<#list invoice.invoiceEntryList as invoiceEntry>{
<#if invoiceEntry.product?? >
"productId":"${(invoiceEntry.product.productId)!'N/A'}",
"productCode":"${(invoiceEntry.product.productCode)!'N/A'}",
"productName":"${(invoiceEntry.product.productName)!'N/A'}",
"productSKU":"${(invoiceEntry.product.productSKU)!'N/A'}",
"productDescription":"${(invoiceEntry.product.productDescription)!'N/A'}",
"categoryPath":"${(invoiceEntry.product.categoryPath)!'N/A'}",
"productType":"${(invoiceEntry.product.productType)!'N/A'}",
"taxes":[<#list invoiceEntry.product.taxDetails as tax>{
"taxId":"${(tax.id)!'N/A'}",
"taxType":"${(tax.taxType)!'N/A'}",
"percentValue":"${(tax.percentValue)!'N/A'}",
"fixedValue":"${(tax.fixedValue)!'N/A'}"
}
<#sep>,
</#list>],
<#else>
"productId":"${'N/A'}",
"productCode":"${'N/A'}",
"productName":"${'N/A'}",
"productSKU":"${'N/A'}",
"productDescription":"${'N/A'}",
"categoryPath":"${'N/A'}",
"productType":"${'N/A'}",
"taxes":[],
</#if>
"quantity":<#if invoiceEntry.uom?? >
"${(invoiceEntry.uom.quantity)!'N/A'}",
<#else>
"${'N/A'}",
</#if>
"totalUnitPrice":{
<#if invoiceEntry.totalUnitPrice?? >
"amount":"${(invoiceEntry.totalUnitPrice.amount)!'N/A'}",
"currency":"${(invoiceEntry.totalUnitPrice.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"totalOfferPrice":{
<#if invoiceEntry.totalOfferPrice?? >
"amount":"${(invoiceEntry.totalOfferPrice.amount)!'N/A'}",
"currency":"${(invoiceEntry.totalOfferPrice.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"totalCalculatedTax":{
<#if invoiceEntry.totalCalculatedTax?? >
"amount":"${(invoiceEntry.totalCalculatedTax.amount)!'N/A'}",
"currency":"${(invoiceEntry.totalCalculatedTax.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"totalDiscount":{
<#if invoiceEntry.totalDiscount?? >
"amount":"${(invoiceEntry.totalDiscount.amount)!'N/A'}",
"currency":"${(invoiceEntry.totalDiscount.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"totalRetailPrice":{
<#if invoiceEntry.totalRetailPrice?? >
"amount":"${(invoiceEntry.totalRetailPrice.amount)!'N/A'}",
"currency":"${(invoiceEntry.totalRetailPrice.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"totalSenderCommission":{
<#if invoiceEntry.totalSenderCommission?? >
"amount":"${(invoiceEntry.totalSenderCommission.amount)!'N/A'}",
"currency":"${(invoiceEntry.totalSenderCommission.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"totalReceiverCommission":{
<#if invoiceEntry.totalReceiverCommission?? >
"amount":"${(invoiceEntry.totalReceiverCommission.amount)!'N/A'}",
"currency":"${(invoiceEntry.totalReceiverCommission.currency)!'N/A'}"
<#else>
"amount":"${'N/A'}",
"currency":"${'N/A'}"
</#if>
},
"data":{<#list invoiceEntry.attributes?keys as key>
"${key!'N/A'}":"${invoiceEntry.attributes[key]!'N/A'}"
<#sep>,
</#list>},
"invoiceEntryProperties":{
<#if invoiceEntry.invoiceEntryProperties??>
<#list invoiceEntry.invoiceEntryProperties?keys as key>
"${key!'N/A'}":"${invoiceEntry.invoiceEntryProperties[key]!'N/A'}"
<#sep>,
</#list>
</#if>}
}<#sep>,
</#list>]
}<#sep>,
</#list>]

</#if>