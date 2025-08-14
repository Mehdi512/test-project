## This Helper Template Carries The Resource Part Of All Components
# You can Specify Different Set Of Resources For Staging/Production Env Here
# These Will Take Effect Based On Env Set In Values.yml file for 'env' VAR.

## HTML_COPIER
{{- define "resources.copier" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: 100m
  memory: 100Mi
limits:
  cpu: 200m
  memory: 200Mi
{{- else if eq .env "production" -}}
requests:
  cpu: 100m
  memory: 100Mi
limits:
  cpu: 200m
  memory: 200Mi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: 100m
  memory: 100Mi
limits:
  cpu: 200m
  memory: 200Mi
{{- end -}}
{{- end -}}

## MINIO
{{- define "resources.minio" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.5'
  memory: 2Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.3'
  memory: 2Gi
limits:
  cpu: '0.8'
  memory: 3Gi
{{- else if eq .env "preproduction" -}}
requests:
  cpu: '0.3'
  memory: 2Gi
limits:
  cpu: '0.8'
  memory: 3Gi
{{- end -}}
{{- end -}}


## RABBITMQ
{{- define "resources.rabbitmq" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.5'
  memory: 2Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.3'
  memory: 2Gi
limits:
  cpu: '0.8'
  memory: 3Gi
{{- end -}}
{{- end -}}


## FILEBEAT
{{- define "resources.filebeat" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.5'
  memory: 2Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.3'
  memory: 2Gi
limits:
  cpu: '0.8'
  memory: 3Gi
{{- end -}}
{{- end -}}


## KANNEL
{{- define "resources.kannel" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.5'
  memory: 2Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.3'
  memory: 2Gi
limits:
  cpu: '0.8'
  memory: 3Gi
{{- end -}}
{{- end -}}


## LOGSTASH
{{- define "resources.logstash" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.5'
  memory: 2Gi
limits:
  cpu: '0.5'
  memory: 2Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.3'
  memory: 2Gi
limits:
  cpu: '0.8'
  memory: 3Gi
{{- end -}}
{{- end -}}


## REDIS
{{- define "resources.redis" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.5'
  memory: 2Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.3'
  memory: 2Gi
limits:
  cpu: '0.8'
  memory: 3Gi
{{- end -}}
{{- end -}}


## KAFKA
{{- define "resources.kafka" -}}
{{- if eq .env "staging" -}}
requests:
  cpu: '0.2'
  memory: 1Gi
limits:
  cpu: '0.5'
  memory: 2Gi
{{- else if eq .env "production" -}}
requests:
  cpu: '0.3'
  memory: 2Gi
limits:
  cpu: '0.8'
  memory: 3Gi
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
