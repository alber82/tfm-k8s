#!/bin/bash

if [[ "${CLUSTER_URL}" == "" ]]; then
  echo 'Missing DATABASE_URL'
  echo 'example -e CLUSTER_URL="kafka-cluster-kafka-bootstrap:9092"'
  exit 1
fi

if [[ "${TEST_TYPE}" == "" ]]; then
  echo 'Missing TEST_TYPE'
  echo 'Allowed values producer and consumer"'
  exit 1
fi

trap shutdown INT

function shutdown() {
  pkill -SIGINT postgresql-prometheus-adapter
}

if [[ "${TEST_TYPE}" == "producer" ]]; then

  CLUSTER_URL=${CLUSTER_URL:-"kafka-cluster-kafka-bootstrap:9092"}
  TOPIC=${TOPIC:-"my-topic"}
  NUM_RECORD=${NUM_RECORD:-"50000000"}
  RECORD_SIZE=${RECORD_SIZE:-"512"}
  THROUGHPUT=${THROUGHPUT:-"1000"}


  echo /opt/kafka/bin/kafka-producer-perf-test.sh \
        --producer-props bootstrap.servers=${CLUSTER_URL} \
        --topic ${TOPIC} \
        --num-records  ${NUM_RECORD} \
        --record-size ${RECORD_SIZE} \
        --throughput ${THROUGHPUT}

  /opt/kafka/bin/kafka-producer-perf-test.sh \
    --producer-props bootstrap.servers=${CLUSTER_URL} \
    --topic ${TOPIC} \
    --num-records  ${NUM_RECORD} \
    --record-size ${RECORD_SIZE} \
    --throughput ${THROUGHPUT}

fi
