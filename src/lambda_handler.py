import awsgi
from flask import (
    Flask,
    jsonify,
)

app = Flask(__name__)


@app.route("/", methods=["GET"])
def index():
    response = {
        "statusCode": 200, 
        "headers": {"Content-Type": "application/json"},
        "body": "\"This is a valid api response\""
    }
    return jsonify(status=200, message=response)


def handler(event, context):
    return awsgi.response(app, event, context)

if __name__ == "__main__":
    event = {"body": None, "httpMethod": "GET", 
             "path": "/", "queryStringParameters": {}, 
             "headers": {"host": "localhost",
                         "x-forwarded-proto": "http"}}
    print(handler(event, None))