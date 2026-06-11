#!/bin/sh
# Redirect Collector output to /dev/null so its own logs don't reach Cloud Logging
# (prevents circular loop: Collector logs → Cloud Logging → Collector reads them back)
/usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml > /dev/null 2>&1 &

sleep 2

# -------------------------------------------------------
# TRACES
# -------------------------------------------------------
export OTEL_BSP_SCHEDULE_DELAY=1000
export OTEL_TRACES_SAMPLER=always_on

exec opentelemetry-instrument waitress-serve --host=0.0.0.0 --port=8080 --threads=4 main:app
