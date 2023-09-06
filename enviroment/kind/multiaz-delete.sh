#!/bin/bash

echo "1. Removing labels from nodes"

for node in $(kubectl get nodes -o custom-columns=node:.metadata.name --no-headers); do
  kubectl label node "${node}" "topology.kubernetes.io/region"-
  kubectl label node "${node}" "topology.kubernetes.io/zone"-
done

echo "2. Deleting Kubernetes API nodes RBAC"
kubectl delete -f resources/dependencies/node-reader/node-reader.yaml