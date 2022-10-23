resource "aws_ssm_parameter" "secret" {
  name        = format("/%s/dynamo_table", local.environment)
  description = "Table name"
  type        = "String"
  value       = local.parameters.table_name

  tags = local.tags
}