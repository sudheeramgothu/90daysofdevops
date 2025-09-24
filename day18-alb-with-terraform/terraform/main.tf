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
# Security Group for ALB
# ----------------------
resource "aws_security_group" "alb_sg" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Allow HTTP/HTTPS from the world to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-alb-sg" })
}

# ----------------------
# ALB
# ----------------------
resource "aws_lb" "this" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, { Name = "${var.name_prefix}-alb" })
}

# ----------------------
# Target Group + attachments (instance mode)
# ----------------------
resource "aws_lb_target_group" "web" {
  name     = "${var.name_prefix}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
    path                = var.health_check_path
    matcher             = "200-399"
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-tg" })
}

resource "aws_lb_target_group_attachment" "targets" {
  for_each         = toset(var.instance_ids)
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = each.value
  port             = var.target_port
}

# ----------------------
# Listeners
# ----------------------

# HTTP listener: redirect to HTTPS
resource "aws_lb_listener" "http" {
  count             = var.enable_http_redirect ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      port        = "443"
      protocol    = "HTTPS"
    }
  }
}

# HTTPS listener: terminate TLS with ACM and forward to target group
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# ----------------------
# Optional ALB access logs (to S3 bucket you own)
# ----------------------
resource "aws_s3_bucket" "access_logs" {
  count  = var.enable_access_logs ? 1 : 0
  bucket = "${var.name_prefix}-alb-logs-${random_id.suffix.hex}"
  force_destroy = true

  tags = merge(var.tags, { Name = "${var.name_prefix}-alb-logs" })
}

resource "random_id" "suffix" {
  byte_length = 2
}

resource "aws_s3_bucket_public_access_block" "logs" {
  count  = var.enable_access_logs ? 1 : 0
  bucket = aws_s3_bucket.access_logs[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_lb_attribute" "access_logs" {
  count              = var.enable_access_logs ? 1 : 0
  load_balancer_arn  = aws_lb.this.arn
  key                = "access_logs.s3.enabled"
  value              = "true"
}

resource "aws_lb_attribute" "access_logs_bucket" {
  count              = var.enable_access_logs ? 1 : 0
  load_balancer_arn  = aws_lb.this.arn
  key                = "access_logs.s3.bucket"
  value              = aws_s3_bucket.access_logs[0].bucket
}

# ----------------------
# Outputs
# ----------------------
output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.web.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}
