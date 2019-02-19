# This is the file that implements a flask server to do inferences. It's the
# file that you will modify to implement the scoring for your own algorithm.
import os
from io import StringIO
import flask

import tensorflow as tf
import numpy as np
import pandas as pd

from keras import backend as K
from keras.models import load_model
from sklearn.preprocessing import StandardScaler

from sklearn.preprocessing import LabelEncoder, OneHotEncoder

prefix = '/opt/ml/'
model_path = os.path.join(prefix, 'model')


# A singleton for holding the model. This simply loads the model and holds it.
# It has a predict function that does a prediction based on the model and the
# input data.
class ScoringService(object):
    model = None

    @classmethod
    def get_model(cls):
        """
        Get the model object for this instance,
        loading it if it's not already loaded.
        """
        if cls.model is None:
            cls.model = load_model(
                os.path.join(model_path, 'ann-churn.h5'))
        return cls.model

    @classmethod
    def predict(cls, input):
        """For the input, do the predictions and return them.
        Args:
            input (a pandas dataframe): The data on which to do the
            predictions.
            There will be one prediction per row in the dataframe
        """
        sess = K.get_session()
        with sess.graph.as_default():
            clf = cls.get_model()
            return clf.predict(input)


def transform_data(dataset):
    dataset = [map(int, s.replace('?', np.nan)) for s in strs]
    # Set features and class variables.
    # dataset = dataset.values
    X = dataset[:, 1:-1]
    y = dataset[:, -1]

    # Feature Scaling
    sc = StandardScaler()
    X = sc.fit_transform(X)

    return pd.DataFrame(X)


# The flask app for serving predictions
app = flask.Flask(__name__)

@app.route('/ping', methods=['GET'])
def ping():
    """
    Determine if the container is working and healthy.
    In this sample container, we declare it healthy if we can load the model
    successfully.
    """

    # Health check -- You can insert a health check here
    health = ScoringService.get_model() is not None
    status = 200 if health else 404
    return flask.Response(
        response='\n',
        status=status,
        mimetype='application/json')


@app.route('/invocations', methods=['POST'])
def transformation():
    """
    Do an inference on a single batch of data. In this sample server, we take
    data as CSV, convert it to a pandas data frame for internal use and then
    convert the predictions back to CSV (which really just means one prediction
    per line, since there's a single column.
    """
    data = None

    # Convert from CSV to pandas
    if flask.request.content_type == 'text/csv':
        data = flask.request.data.decode('utf-8')
        X = transform_data(data)
        s = StringIO.StringIO(X)
        data = pd.read_csv(s, header=None)
    else:
        return flask.Response(
            response='This predictor only supports CSV data',
            status=415,
            mimetype='text/plain')

    print('Invoked with {} records'.format(data.shape[0]))

    # Do the prediction
    predictions = ScoringService.predict(data)

    # Convert from numpy back to CSV
    out = StringIO.StringIO()
    pd.DataFrame(predictions).to_csv(out, header=False, index=False)
    result = out.getvalue()

    return flask.Response(response=result, status=200, mimetype='text/csv')