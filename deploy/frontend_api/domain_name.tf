# Resolve Domain Name with API gateway.
resource "aws_api_gateway_domain_name" "frontend_api" {
  domain_name              = "api.stuartloxton.com"
  regional_certificate_arn = "${var.regional_certificate_arn}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "frontend_api" {
  name    = "${aws_api_gateway_domain_name.frontend_api.domain_name}"
  type    = "A"
  zone_id = "${var.zone_id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_api_gateway_domain_name.frontend_api.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.frontend_api.regional_zone_id}"
  }
}

resource "aws_api_gateway_base_path_mapping" "test" {
  api_id      = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_deployment.deployment.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.frontend_api.domain_name}"
}