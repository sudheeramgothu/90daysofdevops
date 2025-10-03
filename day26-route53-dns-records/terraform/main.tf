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

# ----------------------------------------------------
# Hosted Zone: create or reuse
# ----------------------------------------------------
resource "aws_route53_zone" "this" {
  count = var.create_zone ? 1 : 0
  name  = var.domain_name
  tags  = var.tags
}

locals {
  zone_id = var.create_zone ? aws_route53_zone.this[0].zone_id : var.zone_id
}

# ----------------------------------------------------
# CloudFront Alias (A/AAAA) for site subdomain (e.g., www)
# ----------------------------------------------------
resource "aws_route53_record" "site_a" {
  count   = var.site_subdomain != null && var.site_subdomain != "" ? 1 : 0
  zone_id = local.zone_id
  name    = "${var.site_subdomain}.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "site_aaaa" {
  count   = var.site_subdomain != null && var.site_subdomain != "" ? 1 : 0
  zone_id = local.zone_id
  name    = "${var.site_subdomain}.${var.domain_name}"
  type    = "AAAA"
  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# ----------------------------------------------------
# Root/Apex Alias (A/AAAA) to CloudFront (optional)
# ----------------------------------------------------
resource "aws_route53_record" "apex_a" {
  count   = var.root_apex_alias ? 1 : 0
  zone_id = local.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex_aaaa" {
  count   = var.root_apex_alias ? 1 : 0
  zone_id = local.zone_id
  name    = var.domain_name
  type    = "AAAA"
  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# ----------------------------------------------------
# Optional: ALB Alias (api.<domain>)
# ----------------------------------------------------
resource "aws_route53_record" "alb_a" {
  count   = var.create_alb_record ? 1 : 0
  zone_id = local.zone_id
  name    = "${var.alb_subdomain}.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "alb_aaaa" {
  count   = var.create_alb_record ? 1 : 0
  zone_id = local.zone_id
  name    = "${var.alb_subdomain}.${var.domain_name}"
  type    = "AAAA"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# ----------------------------------------------------
# TXT verification records (map of name => value)
# name can be '@' for the apex (we handle that)
# ----------------------------------------------------
resource "aws_route53_record" "txt" {
  for_each = var.txt_records
  zone_id  = local.zone_id
  name     = each.key == "@" ? var.domain_name : each.key
  type     = "TXT"
  ttl      = var.txt_ttl
  records  = [each.value]
}

# ----------------------------------------------------
# Outputs
# ----------------------------------------------------
output "zone_id" {
  value = local.zone_id
}

output "site_fqdn" {
  value = var.site_subdomain != null && var.site_subdomain != "" ? "${var.site_subdomain}.${var.domain_name}" : null
}

output "alb_fqdn" {
  value = var.create_alb_record ? "${var.alb_subdomain}.${var.domain_name}" : null
}
