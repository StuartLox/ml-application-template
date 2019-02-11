data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "../frontend_api/src"
  output_path = "${path.module}/../lambda.zip"
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