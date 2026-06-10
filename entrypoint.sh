#!/bin/sh
# Start OTEL Collector in background
/usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml &

# Wait for collector to be ready
sleep 2

# opentelemetry-instrument auto-instruments Flask, requests, etc. at startup
export OTEL_LOGS_EXPORTER=otlp
export OTEL_PYTHON_LOG_CORRELATION=true

exec opentelemetry-instrument gunicorn --bind 0.0.0.0:8080 --workers 1 --threads 4 main:app
