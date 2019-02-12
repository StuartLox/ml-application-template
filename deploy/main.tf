terraform {
  backend "s3" {}
}

provider "aws" {
  region = "ap-southeast-2"
  alias = "sys_admin"
}

provider "aws" {
  region = "ap-southeast-2"
  alias = "iam_admin"
}

module "fronend_api" {
  source = "./frontend_api"
}

module "sagemaker" {
  source = "./sagemaker"
}