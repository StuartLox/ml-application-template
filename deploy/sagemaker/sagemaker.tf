provider "aws" {
  region = "ap-southeast-2"
  alias = "sys_admin"
}

provider "aws" {
  region = "ap-southeast-2"
  alias = "iam_admin"
}

resource "aws_sagemaker_notebook_instance" "notebook" {
  provider      = "aws.sys_admin"
  name          = "notebook-spike-instance"
  role_arn      = "${aws_iam_role.sagemaker_role.arn}"
  instance_type = "ml.t2.medium"
  lifecycle_config_name = "cf-cicd-lifecycle"
}

# resource "null_resource" "attach_lifecyle" {
#   provisioner "local-exec" {
#     command = <<EOF
#      pwd
#      chmod +x ./sagemaker/attach_lifecycle.sh
#      ./sagemaker/attach_lifecycle.sh ${aws_sagemaker_notebook_instance.notebook.name}
#     EOF
        
#   }
# }
