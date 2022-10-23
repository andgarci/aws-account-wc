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

resource "aws_iam_role_policy" "codebuild" {
  role   = aws_iam_role.codebuild.name
  policy = aws_iam_policy.basepolicy.policy
}

resource "aws_iam_policy" "basepolicy" {
  name        = format("CodeBuildBasePolicy-WorldCup-%s", local.environment)
  path        = "/"
  description = "CodeBuildBasePolicy"

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