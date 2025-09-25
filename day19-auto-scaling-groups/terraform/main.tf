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
# AMI lookup (Amazon Linux 2023)
# ----------------------
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] # Amazon
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# ----------------------
# IAM Role for SSM (optional but recommended)
# ----------------------
data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
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

resource "aws_iam_role" "ec2_ssm_role" {
  name               = "${var.name_prefix}-ec2-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  tags               = var.tags
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
# Launch Template
# ----------------------
locals {
  user_data = base64encode(<<-EOT
    #!/bin/bash
    set -eux
    dnf update -y || yum update -y
    dnf install -y nginx || yum install -y nginx
    cat >/usr/share/nginx/html/index.html <<'HTML'
    <!doctype html>
    <html><head><meta charset="utf-8"><title>Day 19 — ASG</title></head>
    <body><h1>✅ ASG instance via Launch Template</h1><p>Behind ALB target group.</p></body></html>
    HTML
    systemctl enable nginx && systemctl start nginx
    systemctl enable amazon-ssm-agent || true
    systemctl start amazon-ssm-agent || true
  EOT)
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = local.user_data

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, { Name = "${var.name_prefix}-app" })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------
# Auto Scaling Group
# ----------------------
resource "aws_autoscaling_group" "app" {
  name                      = "${var.name_prefix}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 60
  termination_policies      = ["OldestLaunchTemplate", "ClosestToNextInstanceHour", "Default"]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # Rolling updates via Instance Refresh on LT change
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
      instance_warmup        = 60
    }

    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-app"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------
# Target Tracking Policies (choose one or both; both can coexist)
# ----------------------

# 1) ALB Requests per Target
resource "aws_autoscaling_policy" "req_per_target" {
  name                   = "${var.name_prefix}-tt-req-per-target"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.app.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = var.alb_resource_label
    }
    target_value       = var.requests_per_target
    disable_scale_in   = false
  }
}

# 2) CPU Utilization
resource "aws_autoscaling_policy" "cpu_util" {
  count                  = var.enable_cpu_target_tracking ? 1 : 0
  name                   = "${var.name_prefix}-tt-cpu"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.app.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_target
  }
}

# ----------------------
# Outputs
# ----------------------
output "asg_name" {
  value = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  value = aws_launch_template.app.id
}
