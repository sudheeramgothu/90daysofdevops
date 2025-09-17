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

resource "aws_iam_group" "devops" {
  name = var.group_name
  path = "/teams/devops/"
}

resource "aws_iam_group_policy_attachment" "managed_readonly" {
  count      = var.attach_readonly_access ? 1 : 0
  group      = aws_iam_group.devops.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "s3_readonly_bucket" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [var.target_bucket_arn]
  }

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.target_bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "s3_readonly_bucket" {
  name   = "${var.name_prefix}-S3ReadOnlyBucket"
  policy = data.aws_iam_policy_document.s3_readonly_bucket.json
}

resource "aws_iam_group_policy_attachment" "s3_readonly_bucket" {
  group      = aws_iam_group.devops.name
  policy_arn = aws_iam_policy.s3_readonly_bucket.arn
}

data "aws_iam_policy_document" "deny_without_mfa" {
  statement {
    effect = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

resource "aws_iam_policy" "deny_without_mfa" {
  name   = "${var.name_prefix}-DenyWithoutMFA"
  policy = data.aws_iam_policy_document.deny_without_mfa.json
}

resource "aws_iam_group_policy_attachment" "deny_without_mfa" {
  group      = aws_iam_group.devops.name
  policy_arn = aws_iam_policy.deny_without_mfa.arn
}

resource "aws_iam_user" "user" {
  name          = var.user_name
  path          = "/users/"
  force_destroy = true
  tags = { Team = "DevOps", Env = var.env }
}

resource "aws_iam_user_group_membership" "user_groups" {
  user   = aws_iam_user.user.name
  groups = [aws_iam_group.devops.name]
}

data "aws_iam_policy_document" "prefix_access" {
  count = var.enable_prefix_policy ? 1 : 0
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.target_bucket_arn}/${var.prefix}*"]
  }
}

resource "aws_iam_user_policy" "prefix_access" {
  count  = var.enable_prefix_policy ? 1 : 0
  name   = "${var.name_prefix}-PrefixRead"
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.prefix_access[0].json
}

resource "aws_iam_access_key" "user_key" {
  count = var.create_access_key ? 1 : 0
  user  = aws_iam_user.user.name
}

output "user_arn" {
  value = aws_iam_user.user.arn
}
