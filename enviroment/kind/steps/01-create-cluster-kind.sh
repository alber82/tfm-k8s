#!/bin/bash
set -o errexit

declare -A kubernetesVersionList
kubernetesVersionList[1.25]="kindest/node:v1.25.3@sha256:f52781bc0d7a19fb6c405c2af83abfeb311f130707a0e219175677e366cc45d1"
kubernetesVersionList[1.26]="kindest/node:v1.26.2@sha256:c39462fc9f460e13627cbd835b7d1268e4fd1a82d23833864e33ac1aaa79ee7a"

kindDocker=${kubernetesVersionList[1.25]}

echo "Deploying Kubernetes v${KUBERNETES_VERSION} (kindImage: ${kindDocker})"

 # create registry container unless it already exists
reg_name='kind-registry'
reg_port='5000'
running="$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)"

if [ "${running}" != 'true' ]; then
  docker run \
    -d --restart=always -p "${reg_port}:5000" --name "${reg_name}" \
    registry:2
fi

# create a cluster with the local registry enabled in containerd
cluster_name='tfm-dev'

cat <<EOF | kind create cluster --name="${cluster_name}" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${reg_port}"]
    endpoint = ["http://${reg_name}:${reg_port}"]
nodes:
- role: control-plane
  image: ${kindDocker}
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
  image: ${kindDocker}
- role: worker
  image: ${kindDocker}
- role: worker
  image: ${kindDocker}
- role: worker
  image: ${kindDocker}
- role: worker
  image: ${kindDocker}
EOF

# connect the registry to the cluster network
docker network disconnect "kind" "${reg_name}" || true
docker network connect "kind" "${reg_name}"

# tell https://tilt.dev to use the registry
# https://docs.tilt.dev/choosing_clusters.html#discovering-the-registry
for node in $(kubectl get nodes -o custom-columns=node:.metadata.name --no-headers); do
  kubectl annotate node "${node}" "kind.x-k8s.io/registry=localhost:${reg_port}";
done

kubectl create namespace ns1
kubectl create -n ns1 -f resources/dependencies/np/np.yaml

kubectl create namespace ns2
kubectl create -n ns2 -f resources/dependencies/np/np.yaml

helm repo add k8tz https://k8tz.github.io/k8tz/
helm install k8tz k8tz/k8tz --set timezone=UTC