resource "aws_dynamodb_table" "wctable" {
  name           = "wc_table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "host"

  attribute {
    name = "host"
    type = "S"
  }

#   attribute {
#     name = "champion"
#     type = "S"
#   }

#   attribute {
#     name = "runner-up"
#     type = "S"
#   }

#   attribute {
#     name = "top-scorers"
#     type = "S"
#   }

#   attribute {
#     name = "top-scorers-goals"
#     type = "N"
#   }

#   attribute {
#     name = "year"
#     type = "N"
#   }

  tags = local.tags
}