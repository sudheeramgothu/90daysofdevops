terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "app" {
  backend = "s3"
  config = {
    bucket         = var.backend_bucket
    key            = var.backend_key
    region         = var.backend_region
    dynamodb_table = var.backend_dynamodb_table
    encrypt        = true
  }
}

# Example: Use a remote output to tag a resource
resource "aws_ssm_parameter" "consumer_info" {
  name  = "/day11/consumer/info"
  type  = "String"
  value = "Using app bucket: ${data.terraform_remote_state.app.outputs.app_bucket_name}"
}

output "remote_app_bucket" {
  value = data.terraform_remote_state.app.outputs.app_bucket_name
}