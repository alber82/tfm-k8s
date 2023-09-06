#!/bin/bash
source setup-env

#echo "1. Killing kind-registry"
#docker kill kind-registry
#
#echo "2. Removing kind-registry"
#docker rm kind-registry --force
#kind delete cluster --name=tfm-dev

echo "1. Deleting KinD tfm-dev Cluster"
minikube delete -p tfm-dev

echo "2. Killing port-forward"
pgrep kubectl | xargs kill -9

echo "3. Removing ${DEV_WORKSPACE}"
rm -rf ${DEV_WORKSPACE}

