resource "aws_sagemaker_notebook_instance" "notebook" {
  name          = "notebook-spike-instance"
  role_arn      = "${aws_iam_role.sagemaker_role.arn}"
  instance_type = "ml.t2.medium"
  lifecycle_config_name = "cf-cicd-dev-sagemaker-lifecycle"
  tags = {
    "ml-application" = "sagemaker"
  }
}

resource "null_resource" "build_image" {
  triggers = {
    policy_sha1 = "${sha1(file("${data.archive_file.notebook.output_path}"))}"
  }
  provisioner "local-exec" {
    command = "cd ../notebook/container; echo Add Permissions; chmod u+x; echo Build Image; ./build_image.sh; sh ./build_image.sh"
  }
}