terraform {
  backend "s3" {
    bucket = "my-personal-bucket-for-iac-tools"
    key    = "iac_infrastructure/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-state-lock-iac-infra"
  }
}

data "terraform_remote_state" "iac_tools" {
  backend = "s3"
  config = {
    bucket = "my-personal-bucket-for-iac-tools"
    key    = "iac_tools/terraform.tfstate"
    region = "eu-central-1"
  }
}