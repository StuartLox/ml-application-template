resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  provider    = "aws.sys_admin"
  name        = "MyDemoAPI"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_resource" "MyDemoResource" {
  provider    = "aws.sys_admin"
  rest_api_id = "${aws_api_gateway_rest_api.MyDemoAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.MyDemoAPI.root_resource_id}"
  path_part   = "mydemoresource"
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  provider      = "aws.sys_admin"
  rest_api_id   = "${aws_api_gateway_rest_api.MyDemoAPI.id}"
  resource_id   = "${aws_api_gateway_resource.MyDemoResource.id}"
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "integration" {
  provider                = "aws.sys_admin"
  rest_api_id             = "${aws_api_gateway_rest_api.MyDemoAPI.id}"
  resource_id             = "${aws_api_gateway_resource.MyDemoResource.id}"
  http_method             = "${aws_api_gateway_method.MyDemoMethod.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda.invoke_arn}"
}

resource "aws_lambda_permission" "lambda_permission" {
  provider      = "aws.sys_admin"
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.service_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:ap-southeast-2:224041885527:${aws_api_gateway_rest_api.MyDemoAPI.id}/*/${aws_api_gateway_method.MyDemoMethod.http_method}${aws_api_gateway_resource.MyDemoResource.path}"
}

resource "aws_api_gateway_deployment" "dev" {
  provider    = "aws.sys_admin"
  depends_on  = ["aws_api_gateway_integration.integration"]
  rest_api_id = "${aws_api_gateway_rest_api.MyDemoAPI.id}"
  stage_name  = "dev"
}