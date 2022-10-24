locals {
  iam_policy_arn = [
    aws_iam_policy.basepolicy.arn,
    aws_iam_policy.apigateway.arn,
    aws_iam_policy.ssmparam.arn,
    aws_iam_policy.lambda.arn,
    aws_iam_policy.cloudformation.arn,
    aws_iam_policy.iam_management.arn,
    aws_iam_policy.sqs.arn,
  ]
}
resource "aws_codebuild_project" "worldcup_project" {
  name          = format("WorldCup-BuildProject-%s", local.environment)
  description   = "World Cup Build Project"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }
  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_iam_role" "codebuild" {
  name = "CodeBuildRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  count      = length(local.iam_policy_arn)
  policy_arn = local.iam_policy_arn[count.index]
}

resource "aws_iam_policy" "basepolicy" {
  name        = format("CodeBuildBasePolicy-wcp-%s", local.environment)
  description = "CodeBuild Base Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect = "Allow"
        Resource = [
          format("arn:aws:logs:%s:%s:log-group:*", local.region, local.account_id),
          format("arn:aws:logs:%s:%s:log-group:*:*", local.region, local.account_id),
        ]
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::codepipeline-us-east-1-*",
          "arn:aws:s3:::aws-sam-cli-managed*/*",
          format("arn:aws:s3:::%s*", local.pipeline.bucket_name)
        ]
      },
      {
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ]
        Effect = "Allow"
        Resource = [
          format("arn:aws:codebuild:%s:%s:report-group:/*", local.region, local.account_id),
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "apigateway" {
  name        = format("ApiGatewayPolicy-wcp-%s", local.environment)
  description = "API Gateway Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "apigateway:DELETE",
          "apigateway:PUT",
          "apigateway:PATCH",
          "apigateway:POST",
          "apigateway:GET"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ssmparam" {
  name        = format("SSMParamsPolicy-wcp-%s", local.environment)
  description = "SSM Params  Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:DescribeParameters",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda" {
  name        = format("LambdaFunctionPolicy-wcp-%s", local.environment)
  description = "Lambda Function Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:CreateFunction",
          "lambda:CreateEventSourceMapping",
          "lambda:GetEventSourceMapping",
          "lambda:ListEventSourceMappings",
          "lambda:UpdateEventSourceMapping",
          "lambda:TagResource",
          "lambda:AddPermission",
          "lambda:ListFunctions",
          "lambda:InvokeFunction",
          "lambda:GetFunction",
          "lambda:DeleteFunction",
          "lambda:AddLayerVersionPermission",
          "lambda:UntagResource",
          "lambda:RemoveLayerVersionPermission",
          "lambda:RemovePermission",
          "lambda:GetPolicy"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "sqs" {
  name        = format("SQSPolicy-wcp-%s", local.environment)
  description = "SQS Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudformation" {
  name        = format("CloudFormationPolicy-wcp-%s", local.environment)
  description = "Cloud Formation Policy Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cloudformation:ListStacks",
          "cloudformation:DescribeStackResources",
          "cloudformation:CreateChangeSet",
          "cloudformation:DeleteChangeSet",
          "cloudformation:GetTemplateSummary",
          "cloudformation:DescribeStacks",
          "cloudformation:DescribeStackEvents",
          "cloudformation:DescribeStackSet",
          "cloudformation:ListStackSets",
          "cloudformation:CreateStack",
          "cloudformation:GetTemplate",
          "cloudformation:DescribeChangeSet",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:CreateStackSet",
          "cloudformation:ListChangeSets"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "iam_management" {
  name        = format("IamManagementPolicy-wcp-%s", local.environment)
  description = "IAM Management Policy Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:GetRole",
          "iam:ListRoleTags",
          "iam:UntagRole",
          "iam:TagRole",
          "iam:ListRoles",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePermissionsBoundary",
          "iam:TagPolicy",
          "iam:CreatePolicy",
          "iam:PassRole",
          "iam:DetachRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:UntagPolicy",
          "iam:ListPolicyTags",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy"
        ],
        Resource = "*"
      }
    ]
  })
}
