locals {
  environment = terraform.workspace

  region = {
    development = "us-east-1"
    production  = "us-east-2"
  }

  domain = {

    name = "garciaalcantara.cloud"

    development = {
      domain_name = "dev.garciaalcantara.com"
    }

    production = {
      domain_name = "prod.garciaalcantara.com"
    }
  }

  dns_zone_id    = "Z06499923O3ZY4EAT71FX"
  apigateway_dns = "smrk4xmzea.execute-api.us-east-1.amazonaws.com"

  dynamo = {
    development = {
      table_name = "dev.garciaalcantara.com"
    }

    production = {
      domain_name = "prod.garciaalcantara.com"
    }
  }

  tags = {
    service     = format("apiwc-%s", local.environment)
    environment = local.environment
    managedBy   = "terraform"
  }
}
