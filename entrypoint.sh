#!/bin/sh
# Start OTEL Collector in background
/usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml &

# Wait for collector to be ready
sleep 2

# opentelemetry-instrument auto-instruments Flask, requests, etc. at startup
exec opentelemetry-instrument \
  --logs_exporter otlp \
  --set OTEL_PYTHON_LOG_CORRELATION=true \
  gunicorn --bind 0.0.0.0:8080 --workers 2 main:app
