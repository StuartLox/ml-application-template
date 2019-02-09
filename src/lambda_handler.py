def handler(event, context):
    response = {
            "statusCode": 200, 
            "headers": {"Content-Type": "application/json"},
            "body": "\"This is a valid api response\""
    }
    return response