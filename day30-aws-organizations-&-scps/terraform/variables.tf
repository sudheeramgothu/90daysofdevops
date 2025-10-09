variable "region" {
  description = "Region for provider (Organizations is global, but still requires a region)"
  type        = string
  default     = "us-east-1"
}

variable "org_feature_set" {
  description = "Feature set for the Organization (ALL or CONSOLIDATED_BILLING)"
  type        = string
  default     = "ALL"
}

variable "enable_prod_ou" {
  description = "Create a Prod OU"
  type        = bool
  default     = true
}

variable "enable_sandbox_ou" {
  description = "Create a Sandbox OU"
  type        = bool
  default     = true
}

variable "prod_ou_name" {
  description = "Name of the Prod OU"
  type        = string
  default     = "Prod"
}

variable "sandbox_ou_name" {
  description = "Name of the Sandbox OU"
  type        = string
  default     = "Sandbox"
}

variable "allowed_regions" {
  description = "Region allow list for the AllowOnlyListedRegions SCP"
  type        = list(string)
  default     = ["us-east-1","us-west-2"]
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "30"
  }
}
