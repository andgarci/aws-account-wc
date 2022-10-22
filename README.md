# AWS Simple Application - World Cup historical information API
Infrastructure repository

This simple project is inteded to show how different services are integrated through infrastructure and automation.
Two repositories are implicated whithin this solution

### Iac Terraform
- https://github.com/andgarci/aws-account-wc

### Serverless Application
- https://github.com/andgarci/serverless-wc-data

![Architecture](https://github.com/andgarci/aws-account-wc/blob/main/architecture.jpg?raw=true)


## Pre conditions
- AWS Account
- AWS CLI Installed
- Terraform

### Configure AWS Credentials
```shell
export ENV_NAME=development
export PROFILE_NAME=worldcup

# You will have different options to configure your AWS account, I will provide a couple of options here
# Option 1. Configure Profile
aws configure --profile $PROFILE_NAME
export AWS_PROFILE=$PROFILE_NAME

# Option 2. Programmatic access
export AWS_ACCESS_KEY_ID="ASTSDAAAAAA"
export AWS_SECRET_ACCESS_KEY="PXAXSAXSAAXASXSwHITTB8888888Gt5np"
export AWS_REGION="us-east-1"
```

### Terraform - Create IaaS

The terraform project is ready to recognize two environments: `development` or `production`

```shell
terraform init
terraform workspace select $ENV_NAME || terraform workspace new $ENV_NAME
terraform plan # Optional, to show how the resources are going to be deployed
terraform apply
```

## Application Installation
`git clone git@github.com:andgarci/serverless-wc-data.git`

As the Pipeline was already build via Terraform our next step will be only to use the content of the previouslly cloned repo to the new one to get the application to be functional in an automated way.