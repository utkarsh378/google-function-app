#!/bin/sh
# Start OTEL Collector in background
/usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml &

# Wait for collector to be ready before starting Flask
sleep 2

exec gunicorn --bind 0.0.0.0:8080 --workers 2 main:app
