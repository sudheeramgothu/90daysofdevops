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
# ECR repositories (one per item in var.repositories)
# ----------------------
resource "aws_ecr_repository" "this" {
  for_each = toset(var.repositories)

  name                 = "${var.env}-${each.value}"
  image_tag_mutability = var.image_tag_immutable ? "IMMUTABLE" : "MUTABLE"

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.kms_key_arn != null ? "KMS" : "AES256"
    kms_key         = var.kms_key_arn
  }

  force_delete = var.force_delete # allows destroy when images exist (use with care)
  tags         = merge(var.tags, { Name = "${var.env}-${each.value}" })
}

# ----------------------
# Lifecycle policies (untagged + recent tagged)
# ----------------------
data "aws_ecr_lifecycle_policy_document" "policy" {
  for_each = aws_ecr_repository.this

  rule {
    priority    = 1
    description = "Expire untagged images, keep the most recent N"
    selection {
      tag_status   = "untagged"
      count_type   = "imageCountMoreThan"
      count_number = var.untagged_keep_count
    }
    action {
      type = "expire"
    }
  }

  rule {
    priority    = 2
    description = "Keep only the most recent M tagged images"
    selection {
      tag_status     = "tagged"
      tag_prefix_list = var.tag_prefix_list
      count_type     = "imageCountMoreThan"
      count_number   = var.tagged_keep_count
    }
    action {
      type = "expire"
    }
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = aws_ecr_repository.this
  repository = each.value.name
  policy     = data.aws_ecr_lifecycle_policy_document.policy[each.key].json
}

# ----------------------
# Optional cross-account repository policy (read-only)
# ----------------------
data "aws_iam_policy_document" "cross_account_read" {
  count = length(var.cross_account_reader_arns) > 0 ? 1 : 0

  statement {
    sid = "CrossAccountReadOnly"
    principals {
      type        = "AWS"
      identifiers = var.cross_account_reader_arns
    }
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
}

resource "aws_ecr_repository_policy" "cross" {
  for_each = length(var.cross_account_reader_arns) > 0 ? aws_ecr_repository.this : {}

  repository = each.value.name
  policy     = data.aws_iam_policy_document.cross_account_read[0].json
}

# ----------------------
# IAM policy JSON outputs for CI (push) and runtime (pull)
# Attach these JSON policies to your roles/users in IAM/IdP.
# ----------------------
data "aws_iam_policy_document" "ecr_push" {
  statement {
    sid     = "AllowECRPushPull"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecr_pull" {
  statement {
    sid     = "AllowECRPullOnly"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["*"]
  }
}

# ----------------------
# Outputs
# ----------------------
output "repository_urls" {
  value = { for k, r in aws_ecr_repository.this : k => r.repository_url }
}

output "ecr_push_policy_json" {
  value       = data.aws_iam_policy_document.ecr_push.json
  description = "Attach to CI/agents that need to push images"
}

output "ecr_pull_policy_json" {
  value       = data.aws_iam_policy_document.ecr_pull.json
  description = "Attach to runtimes that only need pull access"
}
