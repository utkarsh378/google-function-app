#!/bin/sh
# Redirect Collector output to /dev/null — only app logs reach Cloud Logging
# (prevents circular loop: Collector logs → Cloud Logging → Pub/Sub → Collector reads them back)
/usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml > /dev/null 2>&1 &

sleep 2

# -------------------------------------------------------
# TRACES
# -------------------------------------------------------
export OTEL_BSP_SCHEDULE_DELAY=1000
export OTEL_TRACES_SAMPLER=always_on

# Disable SDK log export — logs are collected via Pub/Sub, not SDK
export OTEL_LOGS_EXPORTER=none

exec opentelemetry-instrument waitress-serve --host=0.0.0.0 --port=8080 --threads=4 main:app
