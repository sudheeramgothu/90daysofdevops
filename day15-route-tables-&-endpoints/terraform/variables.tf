variable "region" {
  default = "us-east-1"
}

variable "name_prefix" {
  default = "day15"
}

variable "vpc_id" {}
variable "vpc_cidr" {}
variable "private_route_table_ids" {
  type = list(string)
}
variable "public_route_table_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "s3_endpoint_policy_json" {
  default = null
}
variable "dynamodb_endpoint_policy_json" {
  default = null
}
