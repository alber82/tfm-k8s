#!/bin/bash

echo "1. Labeling nodes to test MultiAZ"
REGION="eu-central-1"
COUNTER=1

for node in $(kubectl get nodes -o custom-columns=node:.metadata.name --no-headers); do
  kubectl label node "${node}" "topology.kubernetes.io/region"="${REGION}" --overwrite
  kubectl label node "${node}" "topology.kubernetes.io/zone"="${REGION}-${COUNTER}" --overwrite

  let COUNTER++
done

echo "2. Applying Kubernetes API nodes RBAC"
kubectl apply -f resources/dependencies/node-reader/node-reader.yaml