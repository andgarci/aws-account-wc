resource "aws_dynamodb_table" "wcp_table" {
  name           = local.dynamo.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "year"

  attribute {
    name = "year"
    type = "N"
  }

  attribute {
    name = "host"
    type = "S"
  }

  global_secondary_index {
    name            = "host-index"
    hash_key        = "host"
    write_capacity  = 2
    read_capacity   = 2
    projection_type = "ALL"
  }

}
