locals {
  environment = terraform.workspace

  account_id = data.aws_caller_identity.current.account_id

  pipeline = {
    bucket_name       = format("tfstate-wordcup-%s", local.environment)
    github_connection = "arn:aws:codestar-connections:us-east-1:370421367517:connection/5029d457-2493-411d-8588-de69fcd8ce1c"
    repository_id     = "andgarci/serverless-wc-data"
  }

  region = {
    development = "us-east-1"
    production  = "us-east-2"
  }[local.environment]

  domain = {

    name = "garciaalcantara.cloud"

    development = {
      domain_name = "api-dev.garciaalcantara.cloud"
    }

    production = {
      domain_name = "api.garciaalcantara.cloud"
    }
  }

  dns_zone_id    = "Z06499923O3ZY4EAT71FX"
  apigateway_dns = "smrk4xmzea.execute-api.us-east-1.amazonaws.com"

  dynamo = {
    development = {
      table_name = "dev.garciaalcantara.cloud"
    }

    production = {
      domain_name = "prod.garciaalcantara.cloud"
    }
  }

  parameters = {
    table_name = format("table-wordcup-%s", local.environment)
  }

  tags = {
    service     = format("apiwc-%s", local.environment)
    environment = local.environment
    managedBy   = "terraform"
  }
}
