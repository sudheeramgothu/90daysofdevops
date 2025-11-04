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
    default = {
      instance_types = var.instance_types
      min_size = var.node_group_min
      desired_size = var.node_group_desired
      max_size = var.node_group_max
    }
  }
  cluster_addons = { coredns = { most_recent = true }, kube-proxy = { most_recent = true }, vpc-cni = { most_recent = true } }
  tags = { Project = var.name }
}
