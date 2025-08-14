## CONTAINER_REGISTRY_SECRET
{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imageCredentials.registry (printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.password | b64enc) | b64enc }}
{{- end }}

## RESOURCES
# ALERT_MANAGER
{{- define "resources.alertmanager" -}}
requests:
  cpu: 500m
  memory: 500M
limits:
  cpu: 1500m
  memory: 2Gi
{{- end -}}

# GARAFANA
{{- define "resources.grafana" -}}
requests:
  cpu: 500m
  memory: 1Gi
limits:
  cpu: 1500m
  memory: 2Gi
{{- end -}}

# PROMETHEUS
{{- define "resources.prometheus" -}}
requests:
  cpu: 0.5
  memory: 1Gi
limits:
  cpu: 2
  memory: 8Gi
{{- end -}}
