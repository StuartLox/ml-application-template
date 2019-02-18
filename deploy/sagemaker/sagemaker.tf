resource "aws_sagemaker_notebook_instance" "notebook" {
  name          = "notebook-spike-instance"
  role_arn      = "${aws_iam_role.sagemaker_role.arn}"
  instance_type = "ml.t2.medium"
  lifecycle_config_name = "cf-cicd-dev-sagemaker-lifecycle"
}

data "archive_file" "notebook" {
  type        = "zip"
  source_dir  = "../notebook"
  output_path = "${path.module}/../notebook.zip"
}

