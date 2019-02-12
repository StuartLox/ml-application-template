resource "aws_sagemaker_notebook_instance" "notebook" {
  provider      = "aws.sys_admin"
  name          = "notebook-spike-instance"
  role_arn      = "${aws_iam_role.sagemaker_role.arn}"
  instance_type = "ml.t2.medium"
}

resource "null_resource" "attach_lifecyle" {
  provisioner "local-exec" {
    command = <<EOF
     chmod +x
     attach_lifecycle.sh ${aws_sagemaker_notebook_instance.notebook.name}"
    EOF
        
  }
}
