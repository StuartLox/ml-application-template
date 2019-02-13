import awsgi
import flask
from flask import (
    Flask,
    jsonify,
    request
)

app = Flask(__name__)


@app.route("/data", methods=["GET","POST"])
def index():
    method = request.environ['awsgi.event']['httpMethod']
    if method == "POST":
        return jsonify(message=request.environ['awsgi.event']['body'])
    elif method == "GET":
        return jsonify(message="Hello this is me")

def handler(event, context):
    return awsgi.response(app, event, context)
