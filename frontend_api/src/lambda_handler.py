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
        s = StringIO(data)

def train():
    method = request.environ['awsgi.event']['httpsMethod']
    if method == "POST":
        return jsonify(message)


def get_prediction(body):
    print(body)
    ENDPOINT_NAME = os.environ['ENDPOINTNAME']
    response = runtime.invoke_endpoint(EndpointName=ENDPOINT_NAME,
                                       ContentType='text/csv',
                                       Body="1000025,5,1,1,1,2,1,3,1,1,2")
    result = json.loads(response['Body'].read().decode())
    if result > 0.5:
        return  "Benine"
    elif result < 0.5:
        return "Malignant"


def handler(event, context):
    return awsgi.response(app, event, context)