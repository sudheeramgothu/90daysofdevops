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

resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "ssm.amazonaws.com"
  ]
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
  feature_set          = var.org_feature_set
}

resource "aws_organizations_organizational_unit" "sandbox" {
  count    = var.enable_sandbox_ou ? 1 : 0
  name     = var.sandbox_ou_name
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "prod" {
  count    = var.enable_prod_ou ? 1 : 0
  name     = var.prod_ou_name
  parent_id = aws_organizations_organization.org.roots[0].id
}

data "local_file" "deny_leaving_org"      { filename = "${path.module}/../policies/deny_leaving_org.json" }
data "local_file" "deny_root_access_keys" { filename = "${path.module}/../policies/deny_root_access_keys.json" }
data "local_file" "require_mfa_root"      { filename = "${path.module}/../policies/require_mfa_root.json" }
data "local_file" "deny_stop_cloudtrail"  { filename = "${path.module}/../policies/deny_stop_cloudtrail.json" }
data "local_file" "deny_public_s3"        { filename = "${path.module}/../policies/deny_public_s3.json" }
data "local_file" "allow_only_regions"    { filename = "${path.module}/../policies/allow_only_listed_regions.json" }

resource "aws_organizations_policy" "deny_leaving_org" {
  name = "DenyLeavingOrg"
  type = "SERVICE_CONTROL_POLICY"
  content = data.local_file.deny_leaving_org.content
}

resource "aws_organizations_policy" "deny_root_access_keys" {
  name = "DenyRootAccessKeys"
  type = "SERVICE_CONTROL_POLICY"
  content = data.local_file.deny_root_access_keys.content
}

resource "aws_organizations_policy" "require_mfa_root" {
  name = "RequireMFARoot"
  type = "SERVICE_CONTROL_POLICY"
  content = data.local_file.require_mfa_root.content
}

resource "aws_organizations_policy" "deny_stop_cloudtrail" {
  name = "DenyStopCloudTrail"
  type = "SERVICE_CONTROL_POLICY"
  content = data.local_file.deny_stop_cloudtrail.content
}

resource "aws_organizations_policy" "deny_public_s3" {
  name = "DenyPublicS3"
  type = "SERVICE_CONTROL_POLICY"
  content = data.local_file.deny_public_s3.content
}

locals {
  allowed_regions = var.allowed_regions
  allow_region_policy_template = data.local_file.allow_only_regions.content
  allow_region_policy = replace(local.allow_region_policy_template, "__ALLOWED_REGIONS_JSON__", jsonencode(local.allowed_regions))
}

resource "aws_organizations_policy" "allow_only_regions" {
  name    = "AllowOnlyListedRegions"
  type    = "SERVICE_CONTROL_POLICY"
  content = local.allow_region_policy
}

resource "aws_organizations_policy_attachment" "root_baseline" {
  for_each = {
    deny_leaving_org      = aws_organizations_policy.deny_leaving_org.id
    deny_root_access_keys = aws_organizations_policy.deny_root_access_keys.id
    require_mfa_root      = aws_organizations_policy.require_mfa_root.id
    deny_stop_cloudtrail  = aws_organizations_policy.deny_stop_cloudtrail.id
    deny_public_s3        = aws_organizations_policy.deny_public_s3.id
    allow_only_regions    = aws_organizations_policy.allow_only_regions.id
  }
  policy_id = each.value
  target_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_policy_attachment" "prod_region_lock" {
  count     = var.enable_prod_ou ? 1 : 0
  policy_id = aws_organizations_policy.allow_only_regions.id
  target_id = aws_organizations_organizational_unit.prod[0].id
}

resource "aws_organizations_policy_attachment" "sandbox_region_lock" {
  count     = var.enable_sandbox_ou ? 1 : 0
  policy_id = aws_organizations_policy.allow_only_regions.id
  target_id = aws_organizations_organizational_unit.sandbox[0].id
}

output "org_id"      { value = aws_organizations_organization.org.id }
output "root_id"     { value = aws_organizations_organization.org.roots[0].id }
output "prod_ou_id"  { value = try(aws_organizations_organizational_unit.prod[0].id, null) }
output "sandbox_ou_id" { value = try(aws_organizations_organizational_unit.sandbox[0].id, null) }
