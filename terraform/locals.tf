locals {
  environment = terraform.workspace

  account_id = data.aws_caller_identity.current.account_id

  pipeline = {
    bucket_name   = format("pipeline-bucket-wordcup-%s", local.environment)
    repository_id = "andgarci/serverless-wc-data" # Name of the GitHub repository
  }

  region = {
    development = "us-east-1"
    production  = "us-east-2"
  }[local.environment]
  dynamo = {
    table_name = format("table-wordcup-%s", local.environment)
  }

  parameters = {
    table_name = format("table-wordcup-%s", local.environment)
  }

  ##### Optional section. 
  # In case you want to include this information, you must have
  # identified your domain Hosted ZoneId in Route53.
  # domain = {
  #
  #   name = "garciaalcantara.cloud"
  #
  #   development = {
  #     domain_name = "api-dev.garciaalcantara.cloud"
  #   }
  #
  #   production = {
  #     domain_name = "api.garciaalcantara.cloud"
  #   }
  # }

  # dns_zone_id    = "Z06499923O3ZY4EAT71FX"
  # apigateway_dns = "smrk4xmzea.execute-api.us-east-1.amazonaws.com"  # Get APIGateway DNS Name to set CloudFront Origin and execute terraform project again
  # 
  ##### End of Optional Section

  tags = {
    service     = format("apiwc-%s", local.environment)
    environment = local.environment
    managedBy   = "terraform"
  }
}
