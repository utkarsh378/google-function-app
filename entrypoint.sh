#!/bin/sh
/usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml &

sleep 2

# Force immediate stdout flush — no buffering so filelog receiver sees logs instantly
export PYTHONUNBUFFERED=1

# Redirect stdout+stderr to file at shell level — zero code change in the app.
# The app writes to stdout, the OS captures it to /var/log/app.log.
# OTel Collector filelog receiver picks it up from there.
waitress-serve --host=0.0.0.0 --port=8080 --threads=4 main:app >> /tmp/app.log 2>&1
