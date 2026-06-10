#!/bin/sh
# Start OTEL Collector in background
/usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml &

# Wait for collector to be ready
sleep 2

# opentelemetry-instrument auto-instruments Flask, requests, etc. at startup
export OTEL_LOGS_EXPORTER=otlp
export OTEL_PYTHON_LOG_CORRELATION=true
export OTEL_BSP_SCHEDULE_DELAY=1000
export OTEL_LOG_LEVEL=debug

exec opentelemetry-instrument waitress-serve --host=0.0.0.0 --port=8080 --threads=4 main:app
