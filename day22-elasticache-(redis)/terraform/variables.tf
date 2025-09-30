variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for resources"
  type        = string
  default     = "day22"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for Redis subnet group"
  type        = list(string)
}

variable "app_security_group_ids" {
  description = "App SG IDs allowed to access Redis (6379)"
  type        = list(string)
  default     = []
}

variable "extra_cidr_ingress" {
  description = "Optional CIDRs allowed to access Redis (e.g., bastion)"
  type        = list(string)
  default     = []
}

variable "node_type" {
  description = "Cache node type (e.g., cache.t3.micro)"
  type        = string
  default     = "cache.t3.micro"
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.1"
}

variable "redis_family" {
  description = "Parameter group family (e.g., redis7)"
  type        = string
  default     = "redis7"
}

variable "parameter_overrides" {
  description = "Key-value map for parameter overrides"
  type        = map(string)
  default     = {}
}

# Replication / Availability
variable "num_cache_clusters" {
  description = "Number of cache clusters (cluster mode disabled)"
  type        = number
  default     = 2
}

variable "multi_az_enabled" {
  description = "Enable Multi-AZ (recommended)"
  type        = bool
  default     = true
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover (requires Multi-AZ)"
  type        = bool
  default     = true
}

# Cluster Mode Enabled (Sharding)
variable "cluster_mode_enabled" {
  description = "Enable cluster mode (sharded)"
  type        = bool
  default     = false
}

variable "num_node_groups" {
  description = "Number of shards when cluster mode is enabled"
  type        = number
  default     = 2
}

variable "replicas_per_node_group" {
  description = "Replicas per shard when cluster mode is enabled"
  type        = number
  default     = 1
}

# Maintenance & Snapshots
variable "maintenance_window" {
  description = "Preferred maintenance window (UTC)"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "snapshot_retention_limit" {
  description = "Days to retain automatic snapshots (0 to disable)"
  type        = number
  default     = 3
}

variable "snapshot_window" {
  description = "Preferred snapshot window (UTC)"
  type        = string
  default     = "04:00-05:00"
}

# Auth
variable "auth_token" {
  description = "Provide your own AUTH token (leave empty to auto-generate)"
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "22"
  }
}
