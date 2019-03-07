import awsgi
import flask
import boto3
import logging
import json

from flask import (
    Flask,
    jsonify,
    request
)

app = Flask(__name__)


@app.route("/prediction", methods=["POST"])
def predict():
    method = request.environ['awsgi.event']['httpMethod']
    if flask.request.content_type == 'text/csv':
        data = request.data.decode('utf-8')
        body = StringIO(data)
        get_prediction(body)
    
    else:
        jsonify(message)

@app.route("/train", methods=["POST"])
def train():
    method = request.environ['awsgi.event']['httpsMethod']
    if method == "POST":
        return jsonify(message)


def get_prediction(body):
    # ENDPOINT_NAME = os.environ['ENDPOINT_NAME']
    ENDPOINT_NAME = "ann-churn-2019-03-07-02-37-01-589"
    runtime = boto3.client('sagemaker-runtime', region_name='ap-southeast-2')
    response = runtime.invoke_endpoint(EndpointName=ENDPOINT_NAME,
                                       ContentType='text/csv',
                                       Body=body)
    result = json.loads(response['Body'].read().decode())
    logging.info(result)
    if result > 0.5:
        data = {"Type": "Benine", "Probability" : result}
        return  jsonify(data)
    elif result < 0.5:
        data = {"Type": "Malignant", "Probability" : result}
        return jsonify(data)


def handler(event, context):
    return awsgi.response(app, event, context)