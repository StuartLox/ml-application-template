resource "aws_sagemaker_notebook_instance" "notebook" {
  provider      = "aws.sys_admin"
  name          = "notebook-spike-instance"
  role_arn      = "${aws_iam_role.sagemaker_role.arn}"
  instance_type = "ml.t2.medium"
}