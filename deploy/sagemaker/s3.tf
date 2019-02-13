data "archive_file" "notebook" {
  type        = "zip"
  source_dir  = "../notebook"
  output_path = "${path.module}/../notebook.zip"
}

resource "aws_s3_bucket_object" "object" {
  provider = "aws.sys_admin"
  bucket   = "pocketbook-transaction-data"
  key      = "notebook/notebook.zip"
  source   = "${path.module}/../notebook.zip"
}

resource "aws_s3_bucket" "sagemaker_bucket" {
  bucket = "my-tf-test-bucket"
  acl    = "private"
}