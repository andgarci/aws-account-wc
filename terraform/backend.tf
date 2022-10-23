terraform {
  backend "s3" {
    bucket = "ittrade-tfstate-bucket"
    key    = "world-cup/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}