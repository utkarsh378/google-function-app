FROM python:3.12-slim

WORKDIR /app

# Install otelcol-contrib (has otlphttp + prometheusremotewrite exporters)
RUN apt-get update && apt-get install -y curl && \
    curl -L -o /tmp/otelcol.tar.gz \
    https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.102.0/otelcol-contrib_0.102.0_linux_amd64.tar.gz && \
    tar -xzf /tmp/otelcol.tar.gz -C /usr/local/bin/ otelcol-contrib && \
    rm /tmp/otelcol.tar.gz && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    opentelemetry-bootstrap -a install

COPY . .

RUN chmod +x entrypoint.sh

EXPOSE 8080

CMD ["./entrypoint.sh"]
