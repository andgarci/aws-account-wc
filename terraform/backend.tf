terraform {
  backend "s3" {
    bucket = "ittrade-tfstate-bucket"
    key    = "world-cup/terraform.tfstate"
    region = "us-east-1"
  }
}
