## IF ANY HOSTS TO BE ADDED INTO HOSTALIASES BLOCK OF DEPLOYMENT

{{- define "hostaliases" }}
hostAliases:
{{- range .Values.link_components }}
- ip: "{{ .ip }}"
  hostnames:
  - "{{ .name }}"
{{- end }}
{{- end }}


## This Helper Template Carries The Resource Part Of All Components
# You can Specify Different Set Of Resources For Staging/Production Env Here
# These Will Take Effect Based On Env Set In Values.yml file for 'env' VAR.


## NGINX
{{- define "resources.nginx" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## ACCESS_MANAGEMENT
{{- define "resources.accessmanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## ACCOUNT_MANAGEMENT
{{- define "resources.accountmanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.3'
  memory: 1Gi
limits:
  cpu: '0.3'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## ACCOUNTLINK
{{- define "resources.accountlink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.1'
  memory: 1Gi
limits:
  cpu: '0.1'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## ALERTAPP
{{- define "resources.alertapp" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.1'
  memory: 1Gi
limits:
  cpu: '0.1'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## BATCH_SCHEDULING
{{- define "resources.batchscheduling" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## BI_AGGREAGTOR
{{- define "resources.biaggregator" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## BI_ENGINE
{{- define "resources.biengine" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## BI_TDR_EXPORTER
{{- define "resources.bitdrexporter" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## BUSINESS_LOGIC
{{- define "resources.businesslogic" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.1'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## CELL_SIM
{{- define "resources.cellsim" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.1'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## CONTRACT_MANAGEMENT
{{- define "resources.contractmanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## COREPROXY
{{- define "resources.coreproxy" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.1'
  memory: 500Mi
limits:
  cpu: '0.2'
  memory: 500Mi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 256Mi
limits:
  cpu: '0.2'
  memory: 256Mi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 256Mi
limits:
  cpu: '0.2'
  memory: 256Mi
{{- end -}}
{{- end -}}

## DEALER_MANAGEMENT
{{- define "resources.dealermanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.4'
  memory: 2Gi
limits:
  cpu: '0.4'
  memory: 2Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## FILEBEAT
{{- define "resources.filebeat" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## GROUP_MANAGEMENT
{{- define "resources.groupmanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.1'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}


## QUOTA_MANAGEMENT
{{- define "resources.quotamanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## IDENTITY_MANAGEMENT
{{- define "resources.identitymanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.3'
  memory: 1.5Gi
limits:
  cpu: '0.3'
  memory: 1.5Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## IMS_BRIDGE
{{- define "resources.imsbridge" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## INVENTORY_MANAGEMENT
{{- define "resources.inventorymanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.4'
  memory: 2Gi
limits:
  cpu: '0.4'
  memory: 2Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## KANNEL
{{- define "resources.kannel" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## KYC
{{- define "resources.kyc" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## LDAP_LINK
{{- define "resources.ldaplink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.4'
  memory: 1Gi
limits:
  cpu: '0.4'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## LINK_SIMULATOR
{{- define "resources.linksimulator" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## LOGSTASH
{{- define "resources.logstash" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## NOTIFICATION_MANAGER
{{- define "resources.notificationmanager" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.3'
  memory: 1Gi
limits:
  cpu: '0.3'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## NOTIFICATION_UI
{{- define "resources.notificationui" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.3'
  memory: 1Gi
limits:
  cpu: '0.3'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## OBJECT_STORE_MANAGER
{{- define "resources.objectstore" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## ORDER_MANAGEMENT
{{- define "resources.ordermanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.4'
  memory: 2Gi
limits:
  cpu: '0.4'
  memory: 4Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## OTP_MANAGEMENT
{{- define "resources.otpmanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## PRODUCT_MANAGEMENT
{{- define "resources.productmanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## RABBITMQ
{{- define "resources.rabbitmq" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## REFERENCE_GENERATOR
{{- define "resources.referencegenerator" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## REGION_MANAGEMENT
{{- define "resources.regionmanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## STOCK_ALLOCATION_SYSTEM
{{- define "resources.stockallocationsystem" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## TEMPLATE_MANAGEMENT
{{- define "resources.templatemanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## GRN_PROCESSOR
{{- define "resources.grnprocessor" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## IDM_ASSET_MANAGEMENT
{{- define "resources.idmassetmanagement" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## IDM_BPRS_LINK
{{- define "resources.idmbprslink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## IDM_CIM_LINK
{{- define "resources.idmcimlink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## IDM_CMS_LINK
{{- define "resources.idmcmslink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## IDM_COCKPIT_LINK
{{- define "resources.idmcockpitlink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## GP_IDM_ERP_LINK
{{- define "resources.idmerplink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## GP_IDM_ERS_LINK
{{- define "resources.idmerslink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## GP_IDM_MFS_LINK
{{- define "resources.idmmfslink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## GP_IDM_POL_LINK
{{- define "resources.idmpollink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## GP_IDM_VOUCHER_ACTIVATOR
{{- define "resources.idmvoucheractivator" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}

## HELPER_LINK
{{- define "resources.helperlink" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.2'
  memory: 1Gi
{{- end -}}
{{- end -}}




## PROBES
{{ define "probe" }}
{{- $root := index . 0 -}}
{{- $type := index . 1 -}}
{{- $component := index . 2 -}}
{{- $prefix := printf "%s_" $type -}}

{{- $overrideMap := get $root.Values.probesOverride $component | default dict -}}
{{- $defaultMap := $root.Values.probesDefault -}}

initialDelaySeconds: {{ get $overrideMap (print $prefix "initialDelaySeconds") | default (get $defaultMap (print $prefix "initialDelaySeconds")) }}
periodSeconds: {{ get $overrideMap (print $prefix "periodSeconds") | default (get $defaultMap (print $prefix "periodSeconds")) }}
{{- end }}
