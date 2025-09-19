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

# Random suffix to keep bucket names globally unique
resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  bucket_name = "${var.bucket_name_prefix}-${random_id.suffix.hex}"
}

# S3 bucket
resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy
  tags = merge(var.tags, { "Name" = local.bucket_name })
}

# Block public access
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Server-side encryption (SSE-S3 by default)
resource "aws_s3_bucket_encryption" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? var.kms_key_id : null
    }
  }
}

# Versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "data-transition-expire"
    status = "Enabled"

    filter {
      prefix = "data/"
    }

    transition {
      days          = var.transition_ia_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.transition_glacier_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.expiration_days
    }

    noncurrent_version_transition {
      noncurrent_days = var.noncurrent_transition_days
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_multipart_days
    }
  }

  rule {
    id     = "logs-long-retention"
    status = "Enabled"
    filter {
      prefix = "logs/"
    }
    transition {
      days          = var.logs_transition_days
      storage_class = "GLACIER"
    }
    expiration {
      days = var.logs_expiration_days
    }
  }
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "region" {
  value = var.region
}
