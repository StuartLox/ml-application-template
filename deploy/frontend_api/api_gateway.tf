resource "aws_api_gateway_rest_api" "api" {
  name        = "api"
  description = "Frontend API for connecting with sagemaker"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "dev"
  depends_on  = [
    "aws_api_gateway_integration.lambda_get",
    "aws_api_gateway_integration.lambda_post"
  ]
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_get" {
  rest_api_id      = "${aws_api_gateway_rest_api.api.id}"
  resource_id      = "${aws_api_gateway_resource.proxy.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "lambda_get" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_method.proxy_get.resource_id}"
  http_method             = "${aws_api_gateway_method.proxy_get.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda.invoke_arn}"
}

resource "aws_api_gateway_method" "proxy_post" {
  rest_api_id      = "${aws_api_gateway_rest_api.api.id}"
  resource_id      = "${aws_api_gateway_resource.proxy.id}"
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "lambda_post" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_method.proxy_post.resource_id}"
  http_method             = "${aws_api_gateway_method.proxy_post.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda.invoke_arn}"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}