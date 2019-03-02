import awsgi
import flask
import boto3

from flask import (
    Flask,
    jsonify,
    request
)

app = Flask(__name__)


@app.route("/prediction", methods=["POST"])
def predict():
    method = request.environ['awsgi.event']['httpMethod']
    if method == "POST":
        return jsonify(message=request.environ['awsgi.event']['body'])
        # Convert from CSV to pandas
    if flask.request.content_type == 'text/csv':
        data = request.data.decode('utf-8')
        body = StringIO(data)
        get_prediction(body)

@app.route("/train", methods=["POST"])
def train():
    method = request.environ['awsgi.event']['httpsMethod']
    if method == "POST":
        return jsonify(message)


def get_prediction(body):
    ENDPOINT_NAME = os.environ['ENDPOINTNAME']
    response = runtime.invoke_endpoint(EndpointName=ENDPOINT_NAME,
                                       ContentType='text/csv',
                                       Body=body)
    result = json.loads(response['Body'].read().decode())
    logging.info(result)
    if result > 0.5:
        return  "Benine"
    elif result < 0.5:
        return "Malignant"


def handler(event, context):
    return awsgi.response(app, event, context)