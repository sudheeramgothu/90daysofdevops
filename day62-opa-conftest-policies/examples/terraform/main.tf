terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = { source = "hashicorp/aws" version = "~> 5.0" }
    random = { source = "hashicorp/random" version = "~> 3.6" }
  }
}
provider "aws" { region = "us-east-1" }
resource "random_id" "rand" { byte_length = 2 }
resource "aws_s3_bucket" "demo" { bucket = "day62-${random_id.rand.hex}" acl = "public-read" }
resource "aws_security_group" "ssh_all" {
  name = "ssh-all" vpc_id = "vpc-xxx"
  ingress { from_port=22 to_port=22 protocol="tcp" cidr_blocks=["0.0.0.0/0"] }
}
