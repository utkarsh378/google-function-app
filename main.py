import logging
import json
from flask import Flask, jsonify, request

class JsonFormatter(logging.Formatter):
    def format(self, record):
        return json.dumps({
            "severity": record.levelname,
            "message": record.getMessage(),
            "trace_id": getattr(record, "otelTraceID", "0"),
            "span_id":  getattr(record, "otelSpanID", "0"),
        })

handler = logging.FileHandler("/var/log/app.log")
handler.setFormatter(JsonFormatter())
logging.basicConfig(level=logging.INFO, handlers=[handler])
logger = logging.getLogger(__name__)

app = Flask(__name__)

@app.route("/", methods=["GET"])
def hello():
    name = request.args.get("name", "World")
    logger.info("Request received for name=%s", name)
    return jsonify({"message": f"Hello {name}!", "status": "ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
