# =============================================================================
# VPC MODULE - OUTPUTS
# =============================================================================

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "VPC ARN"
  value       = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "private_subnet_arns" {
  description = "List of private subnet ARNs"
  value       = module.vpc.private_subnet_arns
}

output "private_subnets_cidr_blocks" {
  description = "List of private subnet CIDR blocks"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "public_subnet_arns" {
  description = "List of public subnet ARNs"
  value       = module.vpc.public_subnet_arns
}

output "public_subnets_cidr_blocks" {
  description = "List of public subnet CIDR blocks"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "database_subnets" {
  description = "List of database subnet IDs"
  value       = module.vpc.database_subnets
}

output "database_subnet_arns" {
  description = "List of database subnet ARNs"
  value       = module.vpc.database_subnet_arns
}

output "database_subnets_cidr_blocks" {
  description = "List of database subnet CIDR blocks"
  value       = module.vpc.database_subnets_cidr_blocks
}

output "database_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = module.vpc.database_subnet_group_name
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.natgw_ids
}

output "default_security_group_id" {
  description = "Default security group ID"
  value       = module.vpc.default_security_group_id
}

output "azs" {
  description = "Availability zones used"
  value       = module.vpc.azs
}
