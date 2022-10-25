#
# S3 Bucket - Backend (Optional)
# 
# If you are working with different clients or in a team, it will be a good idea to 
# Keep state in a central location, usually a SharedServices account.
#
# This bucket was created manually outside this project.
# terraform {
#   backend "s3" {
#     bucket = "andres-wcp-my-tfstate-bucket"
#     key    = "world-cup/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

data "aws_caller_identity" "current" {}