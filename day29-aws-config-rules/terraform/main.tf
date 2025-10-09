terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_id" "suffix" {
  byte_length = 3
}

resource "aws_s3_bucket" "config_logs" {
  bucket        = "${var.name_prefix}-config-logs-${random_id.suffix.hex}"
  force_destroy = var.force_destroy
  tags          = merge(var.tags, { Name = "${var.name_prefix}-config-logs" })
}

resource "aws_s3_bucket_public_access_block" "config_logs" {
  bucket                  = aws_s3_bucket.config_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "config_logs" {
  bucket = aws_s3_bucket.config_logs.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

data "aws_iam_policy_document" "assume_config" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "config" {
  name               = "${var.name_prefix}-config-role"
  assume_role_policy = data.aws_iam_policy_document.assume_config.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "config_managed" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_config_configuration_recorder" "this" {
  name     = "${var.name_prefix}-recorder"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported                 = var.record_all_supported
    include_global_resource_types = var.include_global_resources
    resource_types                = var.record_all_supported ? null : var.resource_types
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = "${var.name_prefix}-delivery"
  s3_bucket_name = aws_s3_bucket.config_logs.bucket

  snapshot_delivery_properties {
    delivery_frequency = var.snapshot_frequency
  }

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  is_enabled = true
  name       = aws_config_configuration_recorder.this.name
  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_config_config_rule" "s3_public_read" {
  name = "${var.name_prefix}-s3-public-read-prohibited"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
}

resource "aws_config_config_rule" "s3_public_write" {
  name = "${var.name_prefix}-s3-public-write-prohibited"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }
}

resource "aws_config_config_rule" "ssh_disabled" {
  name = "${var.name_prefix}-incoming-ssh-disabled"
  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }
}

resource "aws_config_config_rule" "ebs_encrypted" {
  name = "${var.name_prefix}-ebs-encrypted-volumes"
  source {
    owner             = "AWS"
    source_identifier = "EBS_ENCRYPTED_VOLUMES"
  }
}

resource "aws_config_config_rule" "iam_password_policy" {
  name = "${var.name_prefix}-iam-password-policy"
  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }
  input_parameters = jsonencode({
    MinimumPasswordLength = "14"
    RequireUppercaseCharacters = "true"
    RequireLowercaseCharacters = "true"
    RequireSymbols = "true"
    RequireNumbers = "true"
    PasswordReusePrevention = "24"
    MaxPasswordAge = "90"
  })
}

resource "aws_config_config_rule" "rds_encrypted" {
  name = "${var.name_prefix}-rds-storage-encrypted"
  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }
}

resource "aws_config_remediation_configuration" "s3_public_block" {
  count                      = var.enable_s3_public_block_remediation ? 1 : 0
  config_rule_name           = aws_config_config_rule.s3_public_read.name
  target_type                = "SSM_DOCUMENT"
  target_id                  = "AWS-ConfigureS3BucketPublicAccessBlock"
  automatic                  = true
  maximum_automatic_attempts = 3
  retry_attempt_seconds      = 60

  parameter {
    name         = "AutomationAssumeRole"
    static_value = aws_iam_role.config.arn
  }

  parameter {
    name = "S3BucketName"
    resource_value { value = "RESOURCE_ID" }
  }

  parameter { name = "BlockPublicAcls"        static_value = "True" }
  parameter { name = "BlockPublicPolicy"      static_value = "True" }
  parameter { name = "IgnorePublicAcls"       static_value = "True" }
  parameter { name = "RestrictPublicBuckets"  static_value = "True" }
}

resource "aws_config_conformance_pack" "baseline" {
  count         = var.enable_conformance_pack ? 1 : 0
  name          = "${var.name_prefix}-baseline-pack"
  template_body = <<-EOT
    Resources:
      S3PublicReadProhibited:
        Type: "AWS::Config::ConfigRule"
        Properties:
          ConfigRuleName: "${var.name_prefix}-pack-s3-public-read-prohibited"
          Source:
            Owner: "AWS"
            SourceIdentifier: "S3_BUCKET_PUBLIC_READ_PROHIBITED"

      S3PublicWriteProhibited:
        Type: "AWS::Config::ConfigRule"
        Properties:
          ConfigRuleName: "${var.name_prefix}-pack-s3-public-write-prohibited"
          Source:
            Owner: "AWS"
            SourceIdentifier: "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"

      EbsEncryptedVolumes:
        Type: "AWS::Config::ConfigRule"
        Properties:
          ConfigRuleName: "${var.name_prefix}-pack-ebs-encrypted"
          Source:
            Owner: "AWS"
            SourceIdentifier: "EBS_ENCRYPTED_VOLUMES"
  EOT
}

output "config_bucket" { value = aws_s3_bucket.config_logs.bucket }
output "recorder_name" { value = aws_config_configuration_recorder.this.name }
output "rules" {
  value = [
    aws_config_config_rule.s3_public_read.name,
    aws_config_config_rule.s3_public_write.name,
    aws_config_config_rule.ssh_disabled.name,
    aws_config_config_rule.ebs_encrypted.name,
    aws_config_config_rule.iam_password_policy.name,
    aws_config_config_rule.rds_encrypted.name
  ]
}
output "conformance_pack_name" { value = try(aws_config_conformance_pack.baseline[0].name, null) }
