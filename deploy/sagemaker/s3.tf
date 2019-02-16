# data "archive_file" "notebook" {
#   type        = "zip"
#   source_dir  = "../notebook"
#   output_path = "${path.module}/../notebook.zip"
# }

resource "aws_s3_bucket" "ml_sagemaker_bucket" {
  provider = "aws.sys_admin"
  bucket   = "ml-sagemaker-bucket"
  region   = "ap-southeast-2"
  acl      = "private"
}

# resource "aws_s3_bucket_object" "object" {
#   provider = "aws.sys_admin"
#   bucket   = "${aws_s3_bucket.ml_sagemaker_bucket.id}"
#   key      = "notebook/notebook.zip"
#   source   = "${path.module}/../notebook.zip"
# }