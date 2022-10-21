locals {
  environment = terraform.workspace

  region = {
    development = "us-east-1"
    production  = "us-east-2"
  }

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

  pipeline = {
    bucket_name = format("tfstate-wordcup-%s", local.environment)
  }

  tags = {
    service     = format("apiwc-%s", local.environment)
    environment = local.environment
    managedBy   = "terraform"
  }
}
