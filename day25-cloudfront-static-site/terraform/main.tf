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

# ----------------------
# S3: site bucket (private, block all public)
# ----------------------
resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
  force_destroy = var.force_destroy
  tags = merge(var.tags, { Name = var.bucket_name })
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "site" {
  bucket = aws_s3_bucket.site.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# (Optional) Access logs bucket
resource "aws_s3_bucket" "logs" {
  count  = var.enable_logging ? 1 : 0
  bucket = "${var.name_prefix}-cf-logs-${random_id.suffix.hex}"
  force_destroy = var.force_destroy
  tags = merge(var.tags, { Name = "${var.name_prefix}-cf-logs" })
}

resource "random_id" "suffix" {
  byte_length = 3
}

# ----------------------
# CloudFront OAC (SigV4 to S3)
# ----------------------
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.name_prefix}-oac"
  description                       = "OAC for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ----------------------
# CloudFront distribution
# ----------------------
locals {
  aliases = compact(concat([var.domain_name], var.alternate_domains))
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.name_prefix} static site"
  aliases             = length(local.aliases) > 0 ? local.aliases : null
  default_root_object = var.default_root_object

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "s3-origin-${aws_s3_bucket.site.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin-${aws_s3_bucket.site.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    compress = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.certificate_arn != null ? var.certificate_arn : null
    ssl_support_method             = var.certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = var.certificate_arn == null ? true : false
  }

  logging_config {
    bucket          = var.enable_logging ? "${aws_s3_bucket.logs[0].bucket_domain_name}" : null
    include_cookies = false
    prefix          = var.enable_logging ? "cloudfront/" : null
  }

  tags = var.tags
}

# ----------------------
# S3 bucket policy: allow CloudFront (this distribution) via OAC
# ----------------------
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "site_policy" {
  statement {
    sid = "AllowCloudFrontServicePrincipalReadOnly"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.site_policy.json
}

# ----------------------
# Helpful outputs
# ----------------------
output "distribution_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "site_bucket_name" {
  value = aws_s3_bucket.site.bucket
}
