# =============================================================================
# RDS MODULE - VARIABLES
# =============================================================================

variable "identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# -----------------------------------------------------------------------------
# ENGINE CONFIGURATION
# -----------------------------------------------------------------------------

variable "engine" {
  description = "Database engine (e.g., postgres, mysql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "family" {
  description = "DB parameter group family"
  type        = string
}

variable "major_engine_version" {
  description = "Major engine version for option group"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

# -----------------------------------------------------------------------------
# STORAGE
# -----------------------------------------------------------------------------

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum storage for autoscaling in GB"
  type        = number
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# DATABASE SETTINGS
# -----------------------------------------------------------------------------

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

# -----------------------------------------------------------------------------
# HIGH AVAILABILITY
# -----------------------------------------------------------------------------

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# BACKUP & MAINTENANCE
# -----------------------------------------------------------------------------

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# MONITORING
# -----------------------------------------------------------------------------

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval (0 to disable)"
  type        = number
  default     = 60
}

# -----------------------------------------------------------------------------
# PARAMETERS
# -----------------------------------------------------------------------------

variable "parameters" {
  description = "List of DB parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# -----------------------------------------------------------------------------
# NETWORK
# -----------------------------------------------------------------------------

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "database_subnet_group_name" {
  description = "Database subnet group name"
  type        = string
}

variable "private_subnets_cidr" {
  description = "Private subnet CIDR blocks for security group"
  type        = list(string)
}

# -----------------------------------------------------------------------------
# TAGS
# -----------------------------------------------------------------------------

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
