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

# provider "aws" {
#   region                      = "us-east-1"
#   access_key                  = "test"
#   secret_key                  = "test"
#   skip_credentials_validation = true
#   skip_metadata_api_check     = true
#   skip_requesting_account_id  = true

#   endpoints {
#     s3 = "http://localhost:4566"
#   }
# }

# Data source for current AWS account ID (for LocalStack)
data "aws_caller_identity" "current" {}

# Data source for current AWS region
data "aws_region" "current" {}