# =============================================================================
# OUTPUTS.TF - Top-Level Outputs
# =============================================================================

# -----------------------------------------------------------------------------
# ENVIRONMENT INFO
# -----------------------------------------------------------------------------
output "environment" {
  description = "Current environment name"
  value       = var.environment
}

output "aws_region" {
  description = "AWS region for this deployment"
  value       = local.aws_region
}

output "is_gdpr_region" {
  description = "Whether this is a GDPR-compliant region"
  value       = local.env.is_gdpr_region
}

output "tenant_type" {
  description = "Tenant type (multi-tenant or single-tenant)"
  value       = local.env.tenant_type
}

# -----------------------------------------------------------------------------
# VPC OUTPUTS
# -----------------------------------------------------------------------------
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "List of database subnet IDs"
  value       = module.vpc.database_subnets
}

# -----------------------------------------------------------------------------
# EKS OUTPUTS
# -----------------------------------------------------------------------------
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS cluster Kubernetes version"
  value       = module.eks.cluster_version
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for cluster authentication"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "eks_cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for IRSA"
  value       = module.eks.cluster_oidc_issuer_url
}

output "eks_update_kubeconfig_command" {
  description = "Command to update kubeconfig for this cluster"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${local.aws_region}"
}

# -----------------------------------------------------------------------------
# RDS OUTPUTS
# -----------------------------------------------------------------------------
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds.db_instance_port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = module.rds.db_instance_name
}

output "rds_master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the master password"
  value       = module.rds.db_instance_master_user_secret_arn
  sensitive   = true
}

# -----------------------------------------------------------------------------
# SQS OUTPUTS
# -----------------------------------------------------------------------------
output "sqs_queue_urls" {
  description = "Map of queue name to queue URL"
  value       = { for k, v in module.sqs : k => v.queue_url }
}

output "sqs_queue_arns" {
  description = "Map of queue name to queue ARN"
  value       = { for k, v in module.sqs : k => v.queue_arn }
}
