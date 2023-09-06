#!/bin/bash
source setup-env

rm -rf  ${DEV_WORKSPACE}
mkdir -p ${DEV_WORKSPACE}

./steps/01-create-cluster.sh
./steps/02-install-helm3.sh
./steps/03-install-prometheus-server.sh
./steps/04-install-timescale.sh
./steps/05-build-and-upload-images.sh
./steps/06-install-kafka.sh
