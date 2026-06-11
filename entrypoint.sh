#!/bin/sh
/usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml &

sleep 2

# -------------------------------------------------------
# TRACES
# -------------------------------------------------------
export OTEL_BSP_SCHEDULE_DELAY=1000
export OTEL_TRACES_SAMPLER=always_on

# Disable SDK log export — logs go to file, collected by filelog receiver
export OTEL_LOGS_EXPORTER=none

# Force Python to write output immediately (no buffering) so filelog
# receiver sees logs right away instead of waiting for the buffer to flush
export PYTHONUNBUFFERED=1

# Redirect stdout+stderr to file at the shell level — no code change needed
# in main.py. The OS sends whatever the app writes to /var/log/app.log.
echo "entrypoint-startup-test" >> /var/log/app.log
exec opentelemetry-instrument waitress-serve --host=0.0.0.0 --port=8080 --threads=4 main:app >> /var/log/app.log 2>&1
