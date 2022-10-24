# AWS Simple Application - World Cup historical information API
Infrastructure repository

This simple project is intended to show how different services are integrated through infrastructure and automation.
Two repositories are implicated in this solution.

### Iac Terraform
- https://github.com/andgarci/aws-account-wc

### Serverless Application
- https://github.com/andgarci/serverless-wc-data

![Architecture](https://github.com/andgarci/aws-account-wc/blob/main/architecture.jpg?raw=true)


## Requirements
- [AWS Account](http://aws.amazon.com/)
- [AWS CLI](https://aws.amazon.com/cli/)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Configure AWS Credentials

Our first step will be to setup our credentials in our terminal to create Infrastructure via Terraform.

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

To get more details and options, please refer to [AWS CLI Configuration.](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
Remember to [do **not use** root credentials.](https://docs.aws.amazon.com/accounts/latest/reference/best-practices-root-user.html)

### Terraform - Create IaaS

The terraform project is ready to recognize two environments: `development` or `production`. Then we are creating our workspace to use this name.

```shell
terraform init
terraform workspace select $ENV_NAME || terraform workspace new $ENV_NAME
terraform plan # Optional, to show how the resources are going to be deployed
terraform apply
```

_You may look at the code in case you want to change regions or specific configurations related to your custom play._

At this point, you have your infrastructure ready for the next phase. Our next step to install the application is to have our application GitHub repository connection in AWS.

All the resources will be ready, but the GitHub connection.

---
**_NOTE:_**   

The aws_codestarconnections_connection resource is created in the state PENDING. Authentication with the connection provider must be completed in the AWS Console.

- [CodeStart Connections](https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html?icmpid=docs_acp_help_panel)
- [Terraform Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection)
---

You can fork this repository in your own account, then use it for the CodeStart connection configuration.

`git clone git@github.com:andgarci/serverless-wc-data.git`

As the Pipeline was already built via Terraform. Our next step will be only to use the content of the previously cloned repo to see how the application will be installed automatically on our platform.

If the Pipeline is not configured, the first time will fail. After configured, the next time you attempt to execute Pipeline or a push is sent to your repository, the Pipeline will work.

### Cleanup

To cleanup the resources created by this lab, please follow these steps:

```shell
# Delete resources from SAM Application
aws cloudformation delete-stack --stack-name serverless-wc-data

# Delete infrasrtucture resources
terraform destroy
```

In case of error related to S3 Buckets, you have to _Emtpy_ refenced buckets and run again the `delete/destroy` commands.