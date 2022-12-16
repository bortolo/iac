terraform {
  backend "s3" {
    bucket = "my-personal-bucket-for-iac-tools"
    key    = "iac_tools/terraform.tfstate"
    region = "eu-central-1"
  }
}