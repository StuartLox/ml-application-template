terraform {
  backend "s3" {}
}

provider "aws" {
  region = "ap-southeast-2"
}

module "sagemaker" {
  source = "./sagemaker"
}

# module "fronend_api" {
#   source = "./frontend_api"
# }