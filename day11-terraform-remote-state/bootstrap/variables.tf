variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix to use for uniquely naming resources"
  type        = string
  default     = "devopsday11"
}