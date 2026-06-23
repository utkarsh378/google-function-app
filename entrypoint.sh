#!/bin/sh

# ============================================================
# NAMED PIPE (FIFO) METHOD — active
# No disk usage, data flows through kernel buffer (64KB max).
# ============================================================
mkfifo /tmp/app.pipe

/usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml &

sleep 2

export PYTHONUNBUFFERED=1

waitress-serve --host=0.0.0.0 --port=8080 --threads=4 main:app >> /tmp/app.pipe 2>&1


# ============================================================
# /tmp FILE METHOD (with log rotation) — commented out
# Swap back by commenting the FIFO block above and uncommenting below.
# ============================================================
# mkfifo not needed for file method
#
# /usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml &
#
# sleep 2
#
# export PYTHONUNBUFFERED=1
#
# rotate_log() {
#   while true; do
#     sleep 10
#     if [ -f /tmp/app.log ] && [ $(wc -c < /tmp/app.log) -gt 102400 ]; then
#       echo "[rotation] /tmp/app.log exceeded 100KB — rotating"
#       mv /tmp/app.log /tmp/app.log.old
#       rm -f /tmp/app.log.old
#       echo "[rotation] old log deleted, memory freed"
#     fi
#   done
# }
# rotate_log &
#
# waitress-serve --host=0.0.0.0 --port=8080 --threads=4 main:app >> /tmp/app.log 2>&1
