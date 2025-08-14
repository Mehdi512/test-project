# Release: GrameenPhone Bangladesh S&D Internal Release 2
## Project/CR Name: GrameenPhone S&D Transformation RFP

### imsbridge
```
Status: Existing

filename: ims-bridge.properties
-update: cache.cluster.1.url=redis:
-with: cache.cluster.1.url=redis://{{ .Values.HOST__redis }}:{{ .Values.PORT__redis }}
```

### KYC
```
Status: Existing

filename: mappings/kyc.sh
-update: curl --location --request PUT 'http://localhost:9200/kyc' \
-with: curl --location --request PUT 'http:{{ .Values.HOST__elasticsearch }}:{{ .Values.PORT__elasticsearch }}/kyc' \

filename: kyc.properties
-update: elasticsearch.1.port=:{{ .Values.PORT__elasticsearch }}
-with: elasticsearch.1.port={{ .Values.PORT__elasticsearch }}
```

### nginx
```
Status: Existing

filename: conf.d/default.conf
-after: ~/api/notificationmanager/* "notificationmanager";
-add: ~/api/stock-allocation-system/* "sas";

newfile: conf.d/services/sas_api.conf
```

### notification-manager
```
Status: Existing

filename: notification-manager.properties
-update: smsprovider.url=http://svc-haproxy:13013/cgi-bin/sendsms?username=ers&password=recharge&from=1200
-with: smsprovider.url=http://{{ .Values.HOST__kannel }}:{{ .Values.PORT__kannel }}/cgi-bin/sendsms?username=ers&password=recharge&from=1200
```

### object-store-manager
```
Status: Existing

filename: object-store-manager/.env
-update:
MYSQL_HOST='{{ .Values.DB_HOST__object_store_manager }}'
MYSQL_PORT={{ .Values.DB_PORT__object_store_manager }}
-with:
MYSQL_HOST='//{{ .Values.DB_HOST__object_store_manager }}'
MYSQL_PORT=//{{ .Values.DB_PORT__object_store_manager }}
```

### product-management
```
Status: Existing

filename: product-management/messages_en.properties
-after: message.operation.invalid.id=Operation id is invalid
-add: message.operation.generate.productSKU.client.failed=Unable to auto-generate productSKU

-after: additional.data.incorrect.definition=Incorrect data definition for validation config.
-add:
categories.fetch.success=Categories fetched successfully
categories.level.empty=Level cannot be null/empty
categories.level.invalid=Level should be a positive number
categories.fetch.failed=Failed to fetch categories
categories.not.found=No categories found

bulk.product.add.validation.failed=Field "{0}" cannot be edited
bulk.product.add.validation.field.not_found=Configured field "{0}" is not accessible
bulk.product.group_type.invalid=Product of type {0} cannot have group type {1}
bulk.product.invalid.category=Product having top category {0} is not allowed
bulk.product.no.category=Product category cannot be null or empty for product {0}

filename: product-management/product-management.properties
-update: pms.database.url=jdbc:mariadb://{{ .Values.DB_HOST__pms }}:{{ .Values.DB_PORT__pms }}:4306/pms
-with: pms.database.url=jdbc:mariadb://{{ .Values.DB_HOST__pms }}:{{ .Values.DB_PORT__pms }}/pms

-update:
spring.redis.host={{ .Values.HOST___redis }}
spring.redis.port={{ .Values.PORT___redis }}
-with:
spring.redis.host={{ .Values.HOST__redis }}
spring.redis.port={{ .Values.PORT__redis }}

-after: validate.additional-field.iccid-range.range=true
-add:
############## Additional Parameter nonEditableFields Config ##############
product.rule.field_to_name.map={"name":"Name","productType":"Product Type","availableFrom":"Available From","availableUntil":"Available Until","categoryId":"Category Id","categoryName":"Category Name","data.PRODUCT_GROUP_TYPE":"Group Type","productSKU":"Product SKU","status":"Status","EANCode":"EANCode","unitPrice.price":"MRP","unitOfMeasure.unit":"UOM","unitOfMeasure.quantity":"Quantity","data.LOT_CONTROLLED":"Lot Controlled"}
# Enabling below property will return the configured list of fields for both product and product variant which cannot be edited
product.rule.restrict.edit.fields.enable=true
product.rule.restrict.edit.fields.mapping=[{"topCategory":"GP Product","productNonEditableFields":["id","code","name","productType","availableFrom","availableUntil","categoryId","categoryName","data.PRODUCT_GROUP_TYPE"],"productVariantNonEditableFields":["productSKU","status","EANCode","availableFrom","availableUntil","unitPrice.price","unitOfMeasure.unit","unitOfMeasure.quantity","data.LOT_CONTROLLED"]},{"topCategory":"Non GP Product","productNonEditableFields":["code"],"productVariantNonEditableFields":["productSKU","EANCode","unitOfMeasure.unit","unitOfMeasure.quantity"]}]

#############################Custom bulk product and variant validation#####################################
# Enabling below property will validate the bulk add/update product and variant request for non-editable fields
product.rule.restrict.bulk.edit.fields.enable=true
# if empty allow all categories in bulk api, else only allow the mentioned ones
product.rule.restrict.bulk.edit.allowed.top_level_categories=GP Product
# this property works if product validator type is customProductModelValidator
product.rule.restrict.bulk.edit.fields.mapping=[{"topCategory":"GP Product","productNonEditableFields":["categoryName","productType"],"productVariantNonEditableFields":["isBundle","unitPrice.currency","data.LOT_CONTROLLED"]}]

############### Config to auto-generate and set productCode and productSKU ##############
# Enabling the below property will auto-generate and set productCode and productSKU while creating products that belong to the specified top level category
product.autogenerate.productSKU.enable=true
product.autogenerate.productSKU.prefix=GPC_
product.autogenerate.productSKU.length=6
# Enabling the below property will set / override the productCode with the auto-generated productSKU of the first product variant
product.autogenerate.override.productCode=true
product.autogenerate.productSKU.eligible.topLevelCategories=Non-GP
#########################################################################################

# this property is required to connect to reference-generator, used for auto-generating productSKU
ers.reference.generator.proxy.uri=http://svc-reference-generator:9997
```

### reference-generator
```
Status: Existing

filename: reference-generator/reference-generator.properties
-update: reference_generator.reference_counter_length=
-with: reference_generator.reference_counter_length=5
```

### region-management-core/templates/regionresponse.ftl
```
Status: Existing

filename: templates/regionresponse.ftl
-updatestatus: major file updates

filename: messages_en.properties
-updatestatus: major file updates
```

### logstash
```
Status: Existing

filename: logstash_approve_kyc.conf
-update: hosts => [ "localhost:9200" ]
-with: hosts => [ "{{ .Values.HOST__elasticsearch }}:{{ .Values.PORT__elasticsearch }}" ]

filename: logstash_data_lake.conf
-update: hosts => [ "localhost:9200" ]
-with: hosts => [ "{{ .Values.HOST__elasticsearch }}:{{ .Values.PORT__elasticsearch }}" ]
-update: hosts => [ "localhost:9200" ]
-with: hosts => [ "{{ .Values.HOST__elasticsearch }}:{{ .Values.PORT__elasticsearch }}" ]
-update: hosts => [ "localhost:9200" ]
-with: hosts => [ "{{ .Values.HOST__elasticsearch }}:{{ .Values.PORT__elasticsearch }}" ]

filename: logstash_is.conf
-update: hosts => [ "localhost:9200" ]
-with: hosts => [ "{{ .Values.HOST__elasticsearch }}:{{ .Values.PORT__elasticsearch }}" ]

filename: logstash_kyc.conf
-update: hosts => [ "localhost:9200" ]
-with: hosts => [ "{{ .Values.HOST__elasticsearch }}:{{ .Values.PORT__elasticsearch }}" ]

filename: logstash_notification_data_lake.conf
-update: hosts => [ "localhost:9200" ]
-with: hosts => [ "{{ .Values.HOST__elasticsearch }}:{{ .Values.PORT__elasticsearch }}" ]

filename: logstash_scc_txe_ingestion.conf
-update: url => "http://localhost:9598/scc-live-data-ingestor/data/v1/ingestData"
-with: "http://svc-scc-ingestor:9598/scc-live-data-ingestor/data/v1/ingestData"
```

### alertapp
```
Status: Existing

filename: alertapp.properties
-update: accounts.db_url=jdbc:mysql://localhost:3306/accounts: 
-with: accounts.db_url=jdbc:mysql://{{ .Values.DB_HOST__accountmanagement }}:{{ .Values.DB_PORT__accountmanagement }}/accounts

-update: dataaggregator.db_url=jdbc:mysql://localhost:3306/dataaggregator: 
-with: dataaggregator.db_url=jdbc:mysql://{{ .Values.DB_HOST__dataaggregator }}:{{ .Values.DB_PORT__dataaggregator }}/dataaggregator

-update: smsprovider.url=http://svc-haproxy:13013/cgi-bin/sendsms?username=ers&password=recharge&from=1234: 
-with: smsprovider.url=http://{{ .Values.HOST__kannel }}:{{ .Values.PORT__kannel }}/cgi-bin/sendsms?username=ers&password=recharge&from=1234

```
### batch-scheduling

```
Status: Existing
 
-addfile: batch-scheduling/templates/stock_allocation_import.ftl

filename: batch-scheduling.properties

-after : bss.omsApi.importOrderUri=/v2/orders
-add:
#-------------------------------------------------------------------------------------
# Stock Allocation Management System (through nginx)
#-------------------------------------------------------------------------------------
bss.samsApi.url=http://svc-nginx:18080/api/sams
bss.samsApi.connectionTimeout=5000
bss.samsApi.requestTimeout=60000
bss.samsApi.importStockAllocationUri=/v1/stock-quota/bulk
bss.samsApi.deleteStockAllocationUri=/v1/stock-quota/revert
bss.samsApi.confirmStockAllocationUri=/v1/stock-quota/keep

-after: template.IMPORT_DEMARCATION=batchschedulingFeed_importGeneric.ftl
-add: template.IMPORT_STOCK_ALLOCATION=batchschedulingFeed_importGeneric.ftl

-after: bss.campaigntargets.file.csv.fieldMapping.target=COLUMN:target
-add:
#-------------------------------------------------------------------------------------
# Stock Allocation Generic
#-------------------------------------------------------------------------------------
bss.stockallocation.defaultAllowedFor=ALL
#Generic import for stock allocation is not allowed
bss.stockallocation.id=Generic
bss.stockallocation.allowedFor=NOT_ALLOWED
bss.stockallocation.operation=NO_OPERATION
bss.stockallocation.file.supportedFormats=CSV
bss.stockallocation.file.format=CSV
bss.stockallocation.file.csv.freemarkerTemplate=stock_allocation_import.ftl
bss.stockallocation.file.fieldValidationRegExp={\
    'Effective Date':'^(0[1-9]|[12][0-9]|3[01])[\/](0[1-9]|1[012])[\/](19|20)\\d\\d$' ,\
    'Expiry Date':'^(0[1-9]|[12][0-9]|3[01])[\/](0[1-9]|1[012])[\/](19|20)\\d\\d$' ,\
    'Payment Refund Date':'^(0[1-9]|[12][0-9]|3[01])[\/](0[1-9]|1[012])[\/](19|20)\\d\\d$' ,\
    'Old Credit Value':'^[\\d]*[\\.]?[\\d]*$' ,\
    'New Credit Value':'^[\\d]*[\\.]?[\\d]*$' \
}
bss.stockallocation.file.numeric.fieldValidationRegExp={\
    'Old Cash Value':'^[\\d]*[\\.]?[\\d]*$' ,\
    'New Cash Value':'^[\\d]*[\\.]?[\\d]*$' \
 }

#-------------------------------------------------------------------------------------
# Stock Allocation CASH
#-------------------------------------------------------------------------------------
bss.stockallocation.type[0].id=STOCK_ALLOCATION_CASH
bss.stockallocation.type[0].allowedFor=${bss.stockallocation.defaultAllowedFor}
bss.stockallocation.type[0].operation=CASH_ALLOCATION
# Comma separated list (can be empty). Two batches having the same tag will not be executed at the same time (no overlapping execution)
bss.stockallocation.type[0].processor.exclusiveTags=allocation
bss.stockallocation.type[0].processor.schedType=immediate
# Scheduling time in spring cron format (when scheduling type is 'scheduled')
bss.stockallocation.type[0].processor.schedTime=0 0 1 * * ?
bss.stockallocation.type[0].processor.schedTypeDelay-sec=30
bss.stockallocation.type[0].processor.failOnError=true
# fallbackOnError parameter is meaningful only when failOnError=true.
# Set fallbackOnError=true to call the external system to revert the import in case of error (default behavior)
# Set fallbackOnError=false to disable fallback in case of error (for backward compatibility)
bss.stockallocation.type[0].processor.fallbackOnError=true
bss.stockallocation.type[0].processor.chunkSize=10
# Number of chunks executed in parallel
# bss.stockallocation.type[0].processor.parallelChunkNb=10
bss.stockallocation.type[0].file.uploadDescription=Stock allocation ${bss.stockallocation.type[0].id} batch file
bss.stockallocation.type[0].file.supportedFormats=CSV
bss.stockallocation.type[0].file.format=CSV
bss.stockallocation.type[0].file.csv.freemarkerTemplate=stock_allocation_import.ftl
bss.stockallocation.type[0].file.csv.header=Partner Code,Allocation Product Item,Allocation Method,Old Cash Value,New Cash Value
bss.stockallocation.type[0].file.csv.fieldMapping.resellerId=COLUMN:Partner Code
bss.stockallocation.type[0].file.csv.fieldMapping.productSKU=COLUMN:Allocation Product Item
bss.stockallocation.type[0].file.csv.fieldMapping.allocationMethod=COLUMN:Allocation Method
bss.stockallocation.type[0].file.csv.fieldMapping.allocation=COLUMN:New Cash Value
bss.stockallocation.type[0].file.csv.fieldMapping.allocationType=CONSTANT:CASH
bss.stockallocation.type[0].file.csv.hasHeader=true
bss.stockallocation.type[0].file.csv.defaultSeparator=,
bss.stockallocation.type[0].file.csv.fieldValidationRegExp=${bss.stockallocation.file.numeric.fieldValidationRegExp}
#-------------------------------------------------------------------------------------
# Stock Allocation CREDIT
#-------------------------------------------------------------------------------------
bss.stockallocation.type[1].id=STOCK_ALLOCATION_CREDIT
bss.stockallocation.type[1].allowedFor=${bss.stockallocation.defaultAllowedFor}
bss.stockallocation.type[1].operation=CREDIT_ALLOCATION
bss.stockallocation.type[1].processor.schedType=immediate
# Comma separated list (can be empty). Two batches having the same tag will not be executed at the same time (no overlapping execution)
bss.stockallocation.type[1].processor.exclusiveTags=allocation
# Scheduling time in spring cron format (when scheduling type is 'scheduled')
bss.stockallocation.type[1].processor.schedTime=0 0 1 * * ?
bss.stockallocation.type[1].processor.schedTypeDelay-sec=30
bss.stockallocation.type[1].processor.failOnError=true
# fallbackOnError parameter is meaningful only when failOnError=true.
# Set fallbackOnError=true to call the external system to revert the import in case of error (default behavior)
# Set fallbackOnError=false to disable fallback in case of error (for backward compatibility)
bss.stockallocation.type[1].processor.fallbackOnError=true
bss.stockallocation.type[1].processor.chunkSize=10
# Number of chunks executed in parallel
# bss.stockallocation.type[1].processor.parallelChunkNb=10
bss.stockallocation.type[1].file.uploadDescription=Stock allocation ${bss.stockallocation.type[1].id} batch file
bss.stockallocation.type[1].file.supportedFormats=CSV
bss.stockallocation.type[1].file.format=CSV
bss.stockallocation.type[1].file.csv.freemarkerTemplate=stock_allocation_import.ftl
bss.stockallocation.type[1].file.csv.header=Partner Code,Allocation Product Item,Allocation Method,Old Credit Value,New Credit Value,Effective Date,Expiry Date,Payment Refund Date
bss.stockallocation.type[1].file.csv.fieldMapping.resellerId=COLUMN:Partner Code
bss.stockallocation.type[1].file.csv.fieldMapping.productSKU=COLUMN:Allocation Product Item
bss.stockallocation.type[1].file.csv.fieldMapping.allocationMethod=COLUMN:Allocation Method
bss.stockallocation.type[1].file.csv.fieldMapping.allocation=COLUMN:New Credit Value
bss.stockallocation.type[1].file.csv.fieldMapping.date_effectiveDate=COLUMN:Effective Date
bss.stockallocation.type[1].file.csv.fieldMapping.date_expiryDate=COLUMN:Expiry Date
bss.stockallocation.type[1].file.csv.fieldMapping.date_paymentRefundDate=COLUMN:Payment Refund Date
bss.stockallocation.type[1].file.csv.fieldMapping.allocationType=CONSTANT:CREDIT
bss.stockallocation.type[1].file.csv.hasHeader=true
bss.stockallocation.type[1].file.csv.defaultSeparator=,
bss.stockallocation.type[1].file.csv.fieldValidationRegExp=${bss.stockallocation.file.fieldValidationRegExp}

filename: messages.properties

-after: message_batch_msg_err_invalid_resellers=All resellers are invalid in the batch
-add: 
message.batch.msg.err.connection=Something went wrong
message.batch.msg.err.internalError=Something went wrong
message.batch.msg.err.invalidInputWithError=Invalid input ({0})
message.batch.msg.err.validationContraint=Invalid input - invalid value error
message.batch.msg.err.invalid.file=Invalid file
message.batch.msg.err.invalid.scheduledDate=Invalid scheduled date
message.batch.msg.err.invalid.fromto=From must be before to

-after: label.serviceType.Voucher=Voucher
-add: label.serviceType.StockAllocation=Stock Allocation

-after: label.serviceSubType.Voucher.Distribute=Distribute vouchers
-add: 
label.serviceSubType.StockAllocation.STOCK_ALLOCATION_CASH=Stock Allocation Cash
label.serviceSubType.StockAllocation.STOCK_ALLOCATION_CREDIT=Stock Allocation Credit

```

### bi-tdr-exporter

```
Status: Existing

filename: bi-tdr-exporter.properties

-update: bi.tdr.elasticsearch.1.url=localhost:
-with: bi.tdr.elasticsearch.1.url={{ .Values.HOST__elasticsearch }}

-update: bi.tdr.elasticsearch.1.port=9200:
-with: bi.tdr.elasticsearch.1.port={{ .Values.PORT__elasticsearch }}
   
-update: db.accounts.url=jdbc:mysql://localhost/accountmanagement: 
-with: db.accounts.url=jdbc:mysql://{{ .Values.DB_HOST__accountmanagement }}:{{ .Values.DB_PORT__accountmanagement }}/accountmanagement

-update: db.refill.url=jdbc:mysql://localhost/Refill:
-with: db.refill.url=jdbc:mysql://{{ .Values.DB_HOST__Refill }}:{{ .Values.DB_PORT__Refill }}/Refill

```

### contract-management-system

```
Status: Existing

filename: contract-management-system.properties

-update: cache.cluster.1.url=redis::
-with: cache.cluster.1.url=redis://{{ .Values.HOST__redis }}:{{ .Values.PORT__redis }}/

-update: #cache.cluster.1.url=rediss:
-with: #cache.cluster.1.url=rediss://{{ .Values.HOST__redis }}:{{ .Values.PORT__redis }}/

```

### coreproxy

```

Status: Existing

filename: coreproxy.properties

-update: smsprovider.url=http://svc-haproxy:13013/cgi-bin/sendsms?username=ers&password=recharge 
-with: smsprovider.url=http://{{ .Values.HOST__kannel }}:{{ .Values.PORT__kannel }}/cgi-bin/sendsms?username=ers&password=recharge

-update: cache.cluster.1.url=redis: 
-with: cache.cluster.1.url=redis://{{ .Values.HOST__redis }}:{{ .Values.PORT__redis }}

```

### dealer-management-system

```

Status: Existing

filename: dealer-management-system.properties

-update: smsprovider.url=http://svc-haproxy:13013/cgi-bin/sendsms?username=ers&password=recharge 
-with: smsprovider.url=http://{{ .Values.HOST__kannel }}:{{ .Values.PORT__kannel }}/cgi-bin/sendsms?username=ers&password=recharge

-update: cache.cluster.1.url=redis: 
-with: cache.cluster.1.url=redis://{{ .Values.HOST__redis }}:{{ .Values.PORT__redis }}


```


### identity-management-system

```

Status: Existing

filename: identity-management.properties

-update: cache.cluster.1.url=redis:
-with: cache.cluster.1.url=redis://{{ .Values.HOST__redis }}:{{ .Values.PORT__redis }}

```


### stock-allocation-system
```
Status: New

New Component 
```

### configs
```
newfile: configs/dependencies.properties
```
