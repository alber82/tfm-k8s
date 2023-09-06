#!/bin/bash

if [[ "${DATABASE_URL}" == "" ]]; then
  echo 'Missing DATABASE_URL'
  echo 'example -e DATABASE_URL="user=<db user> password=<db user password> host=<db host> port=<db port> database=<db name>"'
  exit 1
fi

trap shutdown INT

function shutdown() {
  pkill -SIGINT postgresql-prometheus-adapter
}


web_listen_address="${web_listen_address:-':9201'}"
web_telemetry_path="${web_telemetry_path:-'/metrics'}"
log_level="${log_level:-'info'}"
log_format="${log_format:-'logfmt'}"
pg_partition="${pg_partition:-'hourly'}"
pg_commit_secs="${pg_commit_secs:-30}"
pg_commit_rows="${pg_commit_rows:-20000}"
pg_threads="${pg_threads:-1}"
parser_threads="${parser_threads:-1}"

echo /postgresql-prometheus-adapter \
  --adapter-send-timeout=${adapter_send_timeout} \
  --web-listen-address=${web_listen_address} \
  --web-telemetry-path=${web_telemetry_path} \
  --log.level=${log_level} \
  --log.format=${log_format} \
  --pg-partition=${pg_partition} \
  --pg-commit-secs=${pg_commit_secs} \
  --pg-commit-rows=${pg_commit_rows} \
  --pg-threads=${pg_threads} \
  --parser-threads=${parser_threads}

/postgresql-prometheus-adapter \
  --adapter-send-timeout=${ADAPTER_SEND_TIMEOUT:-30s} \
  --web-listen-address=${WEB_LISTEN_ADDRESS:-'postgresql-prometheus-adapter-internal:9201'} \
  --web-telemetry-path=${WEB_TELEMETRY_PATH:-'/metrics'} \
  --log.level=${LOG_LEVEL:-'info'} \
  --log.format=${LOG_FORMAT:-'logfmt'} \
  --pg-partition=${PG_PARTITIONS:-'hourly'} \
  --pg-commit-secs=${PG_COMMIT_SECS:-30} \
  --pg-commit-rows=${PG_COMMIT_ROWS:-2000} \
  --pg-threads=${PG_THREADS:-1} \
  --parser-threads=${PARSER_THREADS:-5}

