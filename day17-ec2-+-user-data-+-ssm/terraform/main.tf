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
# AMI lookup (Amazon Linux 2023 fallback to AL2)
# ----------------------
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# If you want AL2 instead, switch to this:
# data "aws_ami" "al2" {
#   most_recent = true
#   owners      = ["137112412989"]
#   filter { name = "name"; values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"] }
# }

# ----------------------
# IAM Role for SSM
# ----------------------
data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ec2_ssm_role" {
  name               = "${var.name_prefix}-ec2-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  tags               = var.tags
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = data.aws_iam_policy.ssm_core.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2_ssm_role.name
  tags = var.tags
}

# ----------------------
# User data (cloud-init)
# ----------------------
locals {
  user_data = <<-EOT
  #!/bin/bash
  set -eux

  # Update packages and install nginx
  dnf update -y || yum update -y
  dnf install -y nginx || yum install -y nginx

  # Write a simple index page
  cat >/usr/share/nginx/html/index.html <<'HTML'
  <!doctype html>
  <html>
    <head>
      <meta charset="utf-8">
      <title>Day 17 — EC2 + User Data + SSM</title>
    </head>
    <body>
      <h1>✅ EC2 is up via Terraform</h1>
      <p>Managed by <strong>SSM Session Manager</strong>, no SSH keys required.</p>
    </body>
  </html>
  HTML

  # Enable and start nginx
  systemctl enable nginx
  systemctl start nginx

  # Make sure SSM agent is enabled (usually default on AL2023/AL2)
  systemctl enable amazon-ssm-agent || true
  systemctl start amazon-ssm-agent || true
  EOT
}

# ----------------------
# EC2 Instance
# ----------------------
resource "aws_instance" "web" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = var.associate_public_ip

  user_data = local.user_data

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-web"
  })
}

output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = try(aws_instance.web.public_ip, null)
}

output "private_ip" {
  value = aws_instance.web.private_ip
}
