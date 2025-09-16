variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "backend_bucket" {
  description = "S3 bucket that stores the app's Terraform state"
  type        = string
}

variable "backend_key" {
  description = "Object key (path) of the app's Terraform state"
  type        = string
  default     = "envs/dev/app/terraform.tfstate"
}

variable "backend_region" {
  description = "Region of the S3 backend"
  type        = string
  default     = "us-east-1"
}

variable "backend_dynamodb_table" {
  description = "DynamoDB table used for state locking"
  type        = string
}