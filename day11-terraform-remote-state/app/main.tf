terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {} # configured via -backend-config=env/backend.hcl
}

provider "aws" {
  region = var.region
}

# Demo resource: an SSM Parameter and an S3 bucket (tagged)
resource "aws_ssm_parameter" "app_name" {
  name  = "/day11/app/name"
  type  = "String"
  value = var.app_name
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.name_prefix}-app-bucket-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  byte_length = 2
}

output "app_bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}

output "app_name_param" {
  value = aws_ssm_parameter.app_name.name
}