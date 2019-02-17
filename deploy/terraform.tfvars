terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "personal-account-terraform-state"
      key            = "environment/${get_env("TF_VAR_environment", "")}/terraform-spike.tfstate"
      region         = "ap-southeast-2"
      encrypt        = true
      dynamodb_table = "personal-account-terraform-state-lock"
    }
  }

  terraform {
    extra_arguments "init_args" {
      commands = [
        "init"
      ]
    }
    extra_arguments "environment_vars" {
      arguments = [ 
        "-var-file=./${get_env("TF_VAR_account", "")}.tfvars"
      ]   

      commands = ["${get_terraform_commands_that_need_vars()}"]
    }   
  }
}