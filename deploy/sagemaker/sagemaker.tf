resource "aws_sagemaker_notebook_instance" "notebook" {
  name          = "notebook-spike-instance"
  role_arn      = "${aws_iam_role.sagemaker_role.arn}"
  instance_type = "ml.t2.medium"
  lifecycle_config_name = "cf-cicd-dev-sagemaker-lifecycle"
}

resource "null_resource" "build_image" {
  provisioner "local-exec" {
    command = "cd ../notebook/container; chmod u+x ./build_image.sh; bash ./build_image.sh"
  }
}

