# =============================================================================
# RDS MODULE - OUTPUTS
# =============================================================================

output "db_instance_id" {
  description = "RDS instance ID"
  value       = module.rds.db_instance_identifier
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = module.rds.db_instance_arn
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_address" {
  description = "RDS instance address"
  value       = module.rds.db_instance_address
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = module.rds.db_instance_port
}

output "db_instance_name" {
  description = "Database name"
  value       = module.rds.db_instance_name
}

output "db_instance_username" {
  description = "Master username"
  value       = module.rds.db_instance_username
  sensitive   = true
}

output "db_instance_master_user_secret_arn" {
  description = "ARN of Secrets Manager secret containing master password"
  value       = module.rds.db_instance_master_user_secret_arn
  sensitive   = true
}

output "db_instance_resource_id" {
  description = "RDS resource ID"
  value       = module.rds.db_instance_resource_id
}

output "db_instance_status" {
  description = "RDS instance status"
  value       = module.rds.db_instance_status
}

output "db_instance_availability_zone" {
  description = "Availability zone of RDS instance"
  value       = module.rds.db_instance_availability_zone
}

output "db_parameter_group_id" {
  description = "DB parameter group ID"
  value       = module.rds.db_parameter_group_id
}

output "db_security_group_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds.id
}

output "enhanced_monitoring_iam_role_arn" {
  description = "ARN of enhanced monitoring IAM role"
  value       = module.rds.enhanced_monitoring_iam_role_arn
}
