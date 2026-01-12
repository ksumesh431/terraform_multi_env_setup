# =============================================================================
# VPC MODULE - VARIABLES
# =============================================================================

variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "database_subnets" {
  description = "Database subnet CIDR blocks"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway(s)"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all AZs"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Create one NAT Gateway per AZ"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "create_database_subnet_group" {
  description = "Create a database subnet group"
  type        = bool
  default     = true
}

variable "create_database_subnet_route_table" {
  description = "Create a dedicated route table for database subnets"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "EKS cluster name for subnet tagging"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
