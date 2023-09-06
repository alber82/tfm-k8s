#!/bin/bash
set -o errexit

echo "Deploying Kubernetes"
cluster_name='tfm-dev'

minikube start --cpus 4 --memory 4096 --nodes 5 -p ${cluster_name} --driver=virtualbox --insecure-registry 192.168.59.100:5000 --disk-size 50GB

minikube addons enable registry -p ${cluster_name}

kubectl create namespace ns1
kubectl create -n ns1 -f resources/dependencies/np/np.yaml

kubectl create namespace ns2
kubectl create -n ns2 -f resources/dependencies/np/np.yaml

helm repo add k8tz https://k8tz.github.io/k8tz/
helm install k8tz k8tz/k8tz --set timezone=UTC

kubectl port-forward --namespace kube-system service/registry 5000:80 &