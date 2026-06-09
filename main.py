import logging
from flask import Flask, jsonify, request
from opentelemetry import trace

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
tracer = trace.get_tracer(__name__)

@app.route("/", methods=["GET"])
def hello():
    with tracer.start_as_current_span("hello-handler"):
        name = request.args.get("name", "World")
        logger.info("Request received for name=%s", name)
        return jsonify({"message": f"Hello {name}!", "status": "ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
