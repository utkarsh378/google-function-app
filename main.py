from flask import Flask, jsonify, request
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor

# Send traces to OTEL Collector sidecar running on localhost:4318
exporter = OTLPSpanExporter(endpoint="http://localhost:4318/v1/traces")
provider = TracerProvider()
provider.add_span_processor(BatchSpanProcessor(exporter))
trace.set_tracer_provider(provider)

app = Flask(__name__)
FlaskInstrumentor().instrument_app(app)

tracer = trace.get_tracer(__name__)

@app.route("/", methods=["GET"])
def hello():
    with tracer.start_as_current_span("hello-handler"):
        name = request.args.get("name", "World")
        return jsonify({"message": f"Hello {name}!"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
