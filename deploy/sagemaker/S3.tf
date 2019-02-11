data "archive_file" "model" {
  type        = "zip"
  source_dir  = "../src"
  output_path = "${path.module}/../model.zip"
}

resource "aws_s3_bucket_object" "object" {
  provider = "aws.sys_admin"
  bucket   = "pocketbook-transaction-data"
  key      = "model/model.zip"
  source   = "${path.module}/../model.zip"
  etag     = "${md5(file("${path.module}/../model.zip"))}"
}