variable "region" { default = "us-east-1" }
variable "name_prefix" { default = "day12" }
variable "env" { default = "dev" }
variable "group_name" { default = "devops-engineers" }
variable "user_name" { default = "devops.student" }
variable "target_bucket_arn" {}
variable "prefix" { default = "logs/" }
variable "enable_prefix_policy" { default = false }
variable "attach_readonly_access" { default = false }
variable "create_access_key" { default = false }
