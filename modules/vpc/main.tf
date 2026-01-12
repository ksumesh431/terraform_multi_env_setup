# =============================================================================
# VPC MODULE - MAIN
# =============================================================================
# Uses the official AWS VPC Terraform module
# Source: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws
# =============================================================================

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = var.name
  cidr = var.cidr

  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  # NAT Gateway configuration
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  # DNS settings (required for EKS and RDS)
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # Database subnet group
  create_database_subnet_group       = var.create_database_subnet_group
  create_database_subnet_route_table = var.create_database_subnet_route_table

  # EKS subnet tags for load balancer discovery
  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  # Tags
  tags = merge(
    var.tags,
    {
      Component = "networking"
    }
  )
}
