provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}

terraform {
  backend "s3" = {
    bucket                      = "raghib-sc-terraform-backend"
    key                         = "global/ap-south-1"
    region                      = "ap-south-1"
    skip_credentials_validation = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.46.0"
    }
  }
}

provider "archive" {}