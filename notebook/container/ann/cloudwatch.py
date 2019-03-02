import logging
import json
import time
import boto3

region = "ap-southeast-2"
client = boto3.client('cloudwatch', region_name=region)

class CWEvalMetrics:
    # initialize the region and the model name with the class instantiation
    def __init__(self, model_name, region='ap-southeast-2'):
        self.model_name = model_name
        self.region = region

    # A function to send the training evaluation metrics
    # the metric_type parameters will determine whether the data sent is for training or validation.

    def CW_eval(self, model_name, **kwargs):
        # collecting the loss and accuracy values
        loss = kwargs.get('Loss', 0)
        train_accuracy = kwargs.get('AccuracyTrain')
        test_accuracy = kwargs.get('AccuracyTest')
        print("")
        print("train_accuracy", train_accuracy)
        print("test_accuracy", test_accuracy)

        # Collecting the hyperparameters to be used as the metrics dimensions
        hyperparameter = kwargs.get('hyperparameters')
        optimizer = str(hyperparameter.get('optimizer'))
        epochs = str(hyperparameter.get('epochs'))
        learning_rate = str(hyperparameter.get('learning_rate'))
        response = client.put_metric_data(
            Namespace='/aws/sagemaker/' + model_name,
            MetricData=[
                {
                    'MetricName': 'Training Accuracy',
                    'Dimensions': [
                  { 'Name': 'Model Name', 'Value': model_name },
                  { 'Name': 'Learning Rate', 'Value': learning_rate },
                  { 'Name': 'Optimizer', 'Value': optimizer },
                  { 'Name': 'Epochs', 'Value': epochs},
                    ],
                    'Value': train_accuracy,
                    'Unit': "Percent",
                    'StorageResolution': 1
                },
                {
                    'MetricName': 'Testing Accuracy',
                    'Dimensions': [
                  { 'Name': 'Model Name', 'Value': model_name },
                  { 'Name': 'Learning Rate', 'Value': learning_rate },
                  { 'Name': 'Optimizer', 'Value': optimizer },
                  { 'Name': 'Epochs', 'Value': epochs},
                    ],
                    'Value': test_accuracy,
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
        dashboard_body = '{"widgets":[{"type":"metric","x":0,"y":3,"width":18,"height":9,"properties":{"view":"timeSeries","stacked":false,"metrics":[["/aws/sagemaker/' + self.model_name + '","Training Accuracy","Model Name","' + self.model_name + '","Epochs","' + epochs + '","Optimizer","' + optimizer + '","Learning Rate","' + lr + '"],[".","Testing Accuracy",".",".",".",".",".",".",".","."]],"region":"' + self.region + '","period":30}},{"type":"metric","x":0,"y":0,"width":18,"height":3,"properties":{"view":"singleValue","metrics":[["/aws/sagemaker/' + self.model_name + '","Training Loss","Model Name","' + self.model_name + '","Epochs","' + epochs + '","Optimizer","' + optimizer + '","Learning Rate","' + lr + '"],[".","Training Accuracy",".",".",".",".",".",".",".","."],[".","Testing Accuracy",".",".",".",".",".",".",".","."]],"region":"' + self.region + '","period":30}}]}'
        print(dashboard_body)
        response = client.put_dashboard(DashboardName=db_name, DashboardBody=dashboard_body)
        return response
