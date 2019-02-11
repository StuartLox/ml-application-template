resource "aws_sagemaker_notebook_instance" "notebook" {
  provider      = "aws.sys_admin"
  name          = "notebook-spike-instance"
  role_arn      = "${aws_iam_role.sagemaker_role.arn}"
  instance_type = "ml.t2.medium"
}

resource "null_resource" "stop_notebook" {
  provisioner "local-exec" {
    command = "aws sagemaker stop-notebook-instance --notebook-instance-name ${aws_sagemaker_notebook_instance.notebook.name}"
  }
  depends_on = ["aws_sagemaker_notebook_instance.notebook"]
}

resource "null_resource" "set_lifecycle_config" {
  provisioner "local-exec" {
    command = "aws sagemaker update-notebook-instance --notebook-instance-name ${aws_sagemaker_notebook_instance.notebook.name} --lifecycle-config-name cf-cicd-dev-sagemaker-lifecycle"
  }
  depends_on = ["null_resource.stop_notebook"]
}

resource "null_resource" "start_notebook" {
  provisioner "local-exec" {
    command = "aws sagemaker start-notebook-instance --notebook-instance-name ${aws_sagemaker_notebook_instance.notebook.name}"
  }
  depends_on = ["null_resource.set_lifecycle_config"]
}