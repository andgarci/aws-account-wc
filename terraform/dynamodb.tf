resource "aws_dynamodb_table" "wctable" {
  name           = local.dynamo.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "host"

  attribute {
    name = "host"
    type = "S"
  }
}