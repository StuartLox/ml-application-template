terraform {
  backend "s3" {}
}

provider "aws" {
  region = "ap-southeast-2"
}

module "sagemaker" {
  source = "./sagemaker"
}

module "frontend_api" {
  source                   = "./frontend_api"
  endpoint_name            = "ann-churn-2019-03-14-08-09-53-367"
  zone_id                  = "Z32ZJNY22VS9QO"
  regional_certificate_arn = "arn:aws:acm:ap-southeast-2:224041885527:certificate/090f50d1-caa8-44d9-a6a6-3cd9b752edd0"
}