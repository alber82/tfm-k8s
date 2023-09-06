#!/bin/bash

echo "1. Installing Prometheus server"

kubectl create namespace monitoring
kubectl create -n monitoring -f resources/dependencies/np/np.yaml

kubectl apply -f resources/dependencies/prometheus-server/clusterRole.yaml
kubectl apply -f resources/dependencies/prometheus-server/prometheus-config.yaml
kubectl apply -f resources/dependencies/prometheus-server/deployment.yaml
kubectl apply -f resources/dependencies/prometheus-server/prometheus-service.yaml

echo "1. Installing Prometheus node exporter"
kubectl apply -f resources/dependencies/prometheus-node-exporter/daemonSet.yaml
kubectl apply -f resources/dependencies/prometheus-node-exporter/service.yaml

