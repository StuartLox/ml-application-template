import logging
import json
import time
import boto3
model_name = ""

region = "ap-southeast-2"
client = boto3.client('cloudwatch', region_name=region)

class CWEvalMetrics:
    # initialize the region and the model name with the class instantiation
    def __init__(self, model_name, region='ap-southeast-2'):
        self.model_name = model_name
        self.region = region

    # A function to send the training evaluation metrics
    # the metric_type parameters will determine whether the data sent is for training or validation.

    def CW_eval(self, model_name, is_training,  **kwargs):
        # collecting the loss and accuracy values
        loss = kwargs.get('Loss', 0)
        accuracy = kwargs.get('Accuracy')

        # determine if the passed values are for training or validation
        if is_training:
            metric_type = 'Training'
        else:
            metric_type = 'Validation'

        # Collecting the hyperparameters to be used as the metrics dimensions
        hyperparameter = kwargs.get('hyperparameters')
        optimizer = str(hyperparameter.get('optimizer'))
        epochs = str(hyperparameter.get('epochs'))
        learning_rate = str(hyperparameter.get('learning_rate'))
        response = client.put_metric_data(
            Namespace='/aws/sagemaker/' + model_name,
            MetricData=[
                {
                    'MetricName': metric_type + ' Accuracy',
                    'Dimensions': [
                  { 'Name': 'Model Name', 'Value': model_name },
                  { 'Name': 'Learning Rate', 'Value': learning_rate },
                  { 'Name': 'Optimizer', 'Value': optimizer },
                  { 'Name': 'Epochs', 'Value': epochs},
                    ],
                    'Value': accuracy,
                    'Unit': "Percent",
                    'StorageResolution': 1
                },
                {
                    'MetricName': metric_type + ' Loss',
                    'Dimensions': [
                  { 'Name': 'Model Name', 'Value': model_name },
                  { 'Name': 'Learning Rate', 'Value': learning_rate },
                  { 'Name': 'Optimizer', 'Value': optimizer },
                  { 'Name': 'Epochs', 'Value': epochs},
                    ],
                    'Value': loss,
                    'Unit': "Percent",
                    'StorageResolution': 1
                },
            ]
        )
        return response

    # A function to create a dashboard with the above training metrics.
    def create_dashboard(self, db_name, **kwargs):
        hyperparameter = kwargs.get('hyperparameters')
        job_name = str(hyperparameter.get('sagemaker_job_name'))
        optimizer = str(hyperparameter.get('optimizer'))
        epochs = str(hyperparameter.get('epochs'))
        lr = str(hyperparameter.get('learning_rate'))

        # The dashboard body has the property of the dashboard in JSON format
        dashboard_body = '{"widgets":[{"type":"metric","x":0,"y":3,"width":18,"height":9,"properties":{"view":"timeSeries","stacked":false,"metrics":[["/aws/sagemaker/' + self.model_name + '","Training Loss","Model Name","' + self.model_name + '","Epochs","' + epochs + '","Optimizer","' + optimizer + '","Learning Rate","' + lr + '"],[".","Training Accuracy",".",".",".",".",".",".",".","."],[".","Validation Accuracy",".",".",".",".",".",".",".","."]],"region":"' + self.region + '","period":30}},{"type":"metric","x":0,"y":0,"width":18,"height":3,"properties":{"view":"singleValue","metrics":[["/aws/sagemaker/' + self.model_name + '","Training Loss","Model Name","' + self.model_name + '","Epochs","' + epochs + '","Optimizer","' + optimizer + '","Learning Rate","' + lr + '"],[".","Training Accuracy",".",".",".",".",".",".",".","."],[".","Validation Accuracy",".",".",".",".",".",".",".","."]],"region":"' + self.region + '","period":30}}]}'

        response = client.put_dashboard(DashboardName=db_name, DashboardBody=dashboard_body)
        return response
