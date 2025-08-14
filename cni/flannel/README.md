# CNIs: Deploy Offline

## FOR OFFLINE USE:
These images need to be downloaded, tagged with local container registry & pushed to registry

```
$ docker pull ghcr.io/flannel-io/flannel-cni-plugin:v1.6.2-flannel1
$ docker pull ghcr.io/flannel-io/flannel:v0.26.4

$ docker tag ghcr.io/flannel-io/flannel-cni-plugin:v1.6.2-flannel1 [ CONTAINER_REGISTRY_URL ]/flannel-cni-plugin:v1.6.2-flannel1
$ docker tag ghcr.io/flannel-io/flannel:v0.26.4 [ CONTAINER_REGISTRY_URL ]/flannel:v0.26.4

$ docker push [ CONTAINER_REGISTRY_URL ]/flannel-cni-plugin:v1.6.2-flannel1
$ docker push [ CONTAINER_REGISTRY_URL ]/flannel:v0.26.4
```

After pushing, update these vars with local registry URL in values file & then deploy

```
private_registry: true
container_rgistry_url:
```
