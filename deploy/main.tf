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
  source        = "./frontend_api"
  endpoint_name = "ann-churn-2019-03-07-02-41-44-641"
}