data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "lambda" {
  provider         = "aws.sys_admin"
  filename         = "${data.archive_file.lambda.output_path}"
  function_name    = "${var.service_name}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "lambda_handler.handler"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  runtime          = "python3.6"
  description      = "First Lambda Function to Deploy"
  timeout          = "120"
  memory_size      = "1024"

environment {
    variables = {
      ENV                     = "${var.environment}"
      S3_CONFIG_BUCKET        = "pocketbook-transaction-data"
    }
  }
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  provider  = "aws.iam_admin"
  name      = "lambda"
  role      = "${aws_iam_role.lambda_role.id}"
  policy    = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "xray:*",
            "Resource": "*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject*",
                "s3:GetObject"
            ],
            "Resource": ["arn:aws:s3:::pocketbook-transaction-data*"]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "lambda_role" {
  provider = "aws.iam_admin"
  name     = "${var.service_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}