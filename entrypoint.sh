#!/bin/sh
/usr/local/bin/otelcol-contrib --config=/app/otel-collector-config.yaml &

sleep 2

export PYTHONUNBUFFERED=1

# Rotate /tmp/app.log when it exceeds 100KB (demo size; use 52428800 for 50MB in production).
# Checks every 10 seconds (demo; use 60 in production).
# mv → rm is the critical pair: mv lets OTel finish reading the old file,
# rm is what actually frees the memory. Without rm, /tmp still fills up.
rotate_log() {
  while true; do
    sleep 10
    if [ -f /tmp/app.log ] && [ $(wc -c < /tmp/app.log) -gt 102400 ]; then
      echo "[rotation] /tmp/app.log exceeded 100KB — rotating"
      mv /tmp/app.log /tmp/app.log.old
      rm -f /tmp/app.log.old
      echo "[rotation] old log deleted, memory freed"
    fi
  done
}
rotate_log &

waitress-serve --host=0.0.0.0 --port=8080 --threads=4 main:app >> /tmp/app.log 2>&1
