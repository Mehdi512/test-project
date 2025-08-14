# CNIs: Deploy Offline

## FOR OFFLINE USE:
These images need to be downloaded, tagged with local container registry & pushed to registry

```
$ docker pull docker.io/calico/cni:v3.25.0
$ docker docker.io/calico/node:v3.25.0
$ docker docker.io/calico/kube-controllers:v3.25.0

$ docker tag docker.io/calico/cni:v3.25.0 [ CONTAINER_REGISTRY_URL ]/cni:v3.25.0
$ docker tag docker.io/calico/node:v3.25.0 [ CONTAINER_REGISTRY_URL ]/node:v3.25.0
$ docker tag docker.io/calico/kube-controllers:v3.25.0 [ CONTAINER_REGISTRY_URL ]/kube-controllers:v3.25.0

$ docker push [ CONTAINER_REGISTRY_URL ]/flannel-cni-plugin:v1.6.2-flannel1
$ docker push [ CONTAINER_REGISTRY_URL ]/flannel:v0.26.4
$ docker push [ CONTAINER_REGISTRY_URL ]/kube-controllers:v3.25.0
```

After pushing, update these vars with local registry URL in values file & then deploy

```
private_registry: true
container_rgistry_url:
```
