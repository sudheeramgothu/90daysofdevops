locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  private_subnets = [for i in range(var.az_count): cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnets  = [for i in range(var.az_count): cidrsubnet(var.vpc_cidr, 4, i + 8)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  name = var.name
  cidr = var.vpc_cidr
  azs = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  public_subnet_tags = { "kubernetes.io/role/elb" = "1" }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = "1" }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  cluster_endpoint_public_access = true
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  enable_cluster_creator_admin_permissions = true
  eks_managed_node_groups = {
    ng-on-demand = {
      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
      desired_size   = var.ng_ondemand_desired
      min_size       = var.ng_ondemand_min
      max_size       = var.ng_ondemand_max
      labels = { workload = "core", capacity = "on-demand" }
      taints = []
    }
    ng-spot = {
      instance_types = ["t3.large","t3a.large"]
      capacity_type  = "SPOT"
      desired_size   = var.ng_spot_desired
      min_size       = var.ng_spot_min
      max_size       = var.ng_spot_max
      labels = { workload = "cost-optimized", capacity = "spot" }
      taints = [{ key = "spotOnly", value = "true", effect = "NO_SCHEDULE" }]
    }
    ng-jobs = {
      instance_types = ["m6i.large"]
      capacity_type  = "ON_DEMAND"
      desired_size   = var.ng_jobs_desired
      min_size       = var.ng_jobs_min
      max_size       = var.ng_jobs_max
      labels = { workload = "jobs", capacity = "on-demand" }
      taints = [{ key = "batch", value = "true", effect = "NO_SCHEDULE" }]
    }
  }
  cluster_addons = { coredns = { most_recent = true }, kube-proxy = { most_recent = true }, vpc-cni = { most_recent = true } }
  tags = { Project = var.name }
}
