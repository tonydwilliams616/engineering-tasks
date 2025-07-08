# Configure the AWS Provider for LocalStack
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

# Data source for current AWS account ID (for LocalStack)
data "aws_caller_identity" "current" {}

# Data source for current AWS region
data "aws_region" "current" {}