# INGRESS-CONTROLLER: Deploy Offline

## FOR OFFLINE USE:
These images need to be downloaded, tagged with local container registry & pushed to registry

```
$ docker pull k8s.gcr.io/ingress-nginx/controller:v1.0.4@sha256:545cff00370f28363dad31e3b59a94ba377854d3a11f18988f5f9e56841ef9ef
$ docker pull k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660

$ docker tag k8s.gcr.io/ingress-nginx/controller:v1.0.4@sha256:545cff00370f28363dad31e3b59a94ba377854d3a11f18988f5f9e56841ef9ef [ CONTAINER_REGISTRY_URL ]/controller:v1.0.4
$ docker tag k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660 [ CONTAINER_REGISTRY_URL ]/kube-webhook-certgen:v1.1.1

$ docker push [ CONTAINER_REGISTRY_URL ]/controller:v1.0.4
$ docker push [ CONTAINER_REGISTRY_URL ]/kube-webhook-certgen:v1.1.1
```

After pushing, update these vars with local registry URL in values file & then deploy

```
private_registry: true
container_rgistry_url:
```
