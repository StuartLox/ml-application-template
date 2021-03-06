data "archive_file" "notebook" {
  type        = "zip"
  source_dir  = "../notebook"
  output_path = "${path.module}/../notebook.zip"
}

resource "aws_s3_bucket" "ml_sagemaker_bucket" {
  bucket   = "ml-sagemaker-bucket"
  region   = "ap-southeast-2"
  acl      = "private"
}

resource "aws_s3_bucket_object" "object" {
  bucket   = "${aws_s3_bucket.ml_sagemaker_bucket.id}"
  key      = "notebook/notebook.zip"
  source = "${path.module}/../notebook.zip"
  etag   = "${md5(file("${data.archive_file.notebook.output_path}"))}"
}