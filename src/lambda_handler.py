import awsgi
from flask import (
    Flask,
    jsonify,
)

app = Flask(__name__)


@app.route('/')
def index():
    response = {
        "statusCode": 200, 
        "headers": {"Content-Type": "application/json"},
        "body": "\"This is a valid api response\""
    }
    return jsonify(status=200, message=response)


def handler(event, context):
    return awsgi.response(app, event, context)
