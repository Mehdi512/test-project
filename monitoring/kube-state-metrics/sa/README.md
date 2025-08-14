# PROMETHEUS: Deploy Offline

## FOR OFFLINE USE:
These images need to be downloaded, tagged with local container registry & pushed to registry

```
$ docker pull k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.3.0
$ docker pull prom/prometheus:v2.53.4
$ docker pull prom/alertmanager:v0.28.1
$ docker pull grafana/grafana:11.6.0

$ docker tag k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.3.0 [ CONTAINER_REGISTRY_URL ]/kube-state-metrics:v2.3.0
$ docker tag prom/prometheus:v2.53.4 [ CONTAINER_REGISTRY_URL ]/prometheus:v2.53.4
$ docker tag prom/alertmanager:v0.28.1 [ CONTAINER_REGISTRY_URL ]/alertmanager:v0.28.1
$ docker tag grafana/grafana:11.6.0 [ CONTAINER_REGISTRY_URL ]/grafana:11.6.0

$ docker push CONTAINER_REGISTRY_URL ]/kube-state-metrics:v2.3.0
$ docker push CONTAINER_REGISTRY_URL ]/prometheus:v2.53.4
$ docker push CONTAINER_REGISTRY_URL ]/alertmanager:v0.28.1
$ docker push CONTAINER_REGISTRY_URL ]/grafana:11.6.0
```

After pushing, update these vars with local registry URL in values file & then deploy

```
private_registry: true
container_rgistry_url:
```
