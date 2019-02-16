terraform {
  backend "s3" {}
}

provider "aws" {
  region = "ap-southeast-2"
  alias = "sys_admin"
  source = "https://github.com/StuartLox/terraform-provider-aws"
}

provider "aws" {
  region = "ap-southeast-2"
  alias = "iam_admin"
}

module "sagemaker" {
  source = "./sagemaker"
}

# module "fronend_api" {
#   source = "./frontend_api"
# }