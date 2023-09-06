#!/bin/bash
set -e

export DOCKER_BUILDKIT=1

docker build --build-arg VERSION=0.0.0 -t localhost:5000/kafka/kafka-perf-test:0.1 -f ../../kafka-perf-test/Dockerfile ../..
docker push localhost:5000/kafka/kafka-perf-test:0.1

docker build --build-arg VERSION=0.0.0 -t localhost:5000/albertogomez/scheduler:0.0.0 -f ../../scheduler/Dockerfile ../..
docker push localhost:5000/albertogomez/scheduler:0.0.0

docker build --build-arg VERSION=0.0.0 -t localhost:5000/albertogomez/scheduler-operator:0.0.0 -f ../../operator/src/main/go/Dockerfile ../..
docker push localhost:5000/albertogomez/scheduler-operator:0.0.0

docker build --build-arg VERSION=0.0.0 -t localhost:5000/albertogomez/random-scheduler:0.0.0 -f ../../random-scheduler/Dockerfile ../..
docker push localhost:5000/albertogomez/random-scheduler:0.0.0
