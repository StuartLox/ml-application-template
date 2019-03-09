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
    logging.info(f"Content-Type: {flask.request.content_type})
    if flask.request.content_type == 'text/csv':
        data = request.data.decode('utf-8')
        body = StringIO(data)
        data = get_prediction(body)
        return jsonify(data)
    
    else:
        return jsonify(request.environ['awsgi.event']['body'])

@app.route("/train", methods=["POST"])
def train():
    method = request.environ['awsgi.event']['httpsMethod']
    if method == "POST":
        return jsonify(message=request.environ['awsgi.event']['body'])


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
        return {"Type": "Benine", "Probability" : result}

    elif result < 0.5:
        return {"Type": "Malignant", "Probability" : result}


def handler(event, context):
    return awsgi.response(app, event, context)