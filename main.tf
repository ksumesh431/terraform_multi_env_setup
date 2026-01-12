# =============================================================================
# MAIN.TF - Root Module Orchestrator
# =============================================================================
# This file orchestrates all infrastructure modules using configuration 
# loaded from config.yaml (single source of truth)
# =============================================================================

# -----------------------------------------------------------------------------
# VPC MODULE
# -----------------------------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  name        = "${local.name_prefix}-vpc"
  environment = var.environment

  # Network configuration from config.yaml
  cidr             = local.vpc_config.cidr
  azs              = local.vpc_config.azs
  private_subnets  = local.vpc_config.private_subnets
  public_subnets   = local.vpc_config.public_subnets
  database_subnets = local.vpc_config.database_subnets

  # NAT Gateway configuration
  enable_nat_gateway     = local.vpc_config.enable_nat_gateway
  single_nat_gateway     = local.vpc_config.single_nat_gateway
  one_nat_gateway_per_az = local.vpc_config.one_nat_gateway_per_az

  # DNS settings
  enable_dns_hostnames = local.vpc_config.enable_dns_hostnames
  enable_dns_support   = local.vpc_config.enable_dns_support

  # Database subnet group
  create_database_subnet_group       = local.vpc_config.create_database_subnet_group
  create_database_subnet_route_table = local.vpc_config.create_database_subnet_route_table

  # EKS cluster name for subnet tagging
  cluster_name = local.name_prefix

  tags = local.tags
}

# -----------------------------------------------------------------------------
# EKS MODULE
# -----------------------------------------------------------------------------
module "eks" {
  source = "./modules/eks"

  cluster_name    = local.name_prefix
  cluster_version = local.eks_config.cluster_version
  environment     = var.environment

  # VPC dependencies
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Endpoint access
  cluster_endpoint_public_access       = local.eks_config.cluster_endpoint_public_access
  cluster_endpoint_private_access      = local.eks_config.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = local.eks_config.cluster_endpoint_public_access_cidrs

  # Logging
  cluster_enabled_log_types     = local.eks_config.cluster_enabled_log_types
  cluster_log_retention_in_days = local.eks_config.cluster_log_retention_in_days

  # Encryption
  cluster_encryption_config       = local.eks_config.cluster_encryption_config
  kms_key_deletion_window_in_days = local.eks_config.kms_key_deletion_window_in_days

  # IRSA and Pod Identity
  enable_irsa               = local.eks_config.enable_irsa
  enable_pod_identity_agent = local.eks_config.enable_pod_identity_agent

  # Authentication
  authentication_mode                         = local.eks_config.authentication_mode
  bootstrap_cluster_creator_admin_permissions = local.eks_config.bootstrap_cluster_creator_admin_permissions

  # Addons
  cluster_addons = local.eks_config.cluster_addons

  # Node groups
  node_groups = local.eks_config.node_groups

  # Security group rules
  cluster_security_group_additional_rules = local.eks_config.cluster_security_group_additional_rules
  node_security_group_additional_rules    = local.eks_config.node_security_group_additional_rules

  tags = local.tags
}

# -----------------------------------------------------------------------------
# RDS MODULE
# -----------------------------------------------------------------------------
module "rds" {
  source = "./modules/rds"

  identifier  = "${local.name_prefix}-postgres"
  environment = var.environment

  # Engine configuration
  engine               = local.rds_config.engine
  engine_version       = local.rds_config.engine_version
  family               = local.rds_config.family
  major_engine_version = local.rds_config.major_engine_version
  instance_class       = local.rds_config.instance_class

  # Storage
  allocated_storage     = local.rds_config.allocated_storage
  max_allocated_storage = local.rds_config.max_allocated_storage
  storage_type          = local.rds_config.storage_type
  storage_encrypted     = local.rds_config.storage_encrypted

  # Database settings
  db_name     = local.rds_config.db_name
  db_username = local.rds_config.db_username
  db_port     = local.rds_config.db_port

  # High availability
  multi_az = local.rds_config.multi_az

  # Backup configuration
  backup_retention_period = local.rds_config.backup_retention_period
  backup_window           = local.rds_config.backup_window
  maintenance_window      = local.rds_config.maintenance_window
  skip_final_snapshot     = local.rds_config.skip_final_snapshot
  deletion_protection     = local.rds_config.deletion_protection

  # Monitoring
  performance_insights_enabled = local.rds_config.performance_insights_enabled
  monitoring_interval          = local.rds_config.monitoring_interval

  # Parameters
  parameters = local.rds_config.parameters

  # VPC dependencies
  vpc_id                     = module.vpc.vpc_id
  database_subnet_group_name = module.vpc.database_subnet_group_name
  private_subnets_cidr       = module.vpc.private_subnets_cidr_blocks

  tags = local.tags
}

# -----------------------------------------------------------------------------
# SQS MODULE (one per queue)
# -----------------------------------------------------------------------------
module "sqs" {
  source   = "./modules/sqs"
  for_each = local.sqs_queues

  name        = "${local.name_prefix}-${each.key}"
  queue_name  = each.key
  environment = var.environment

  # Queue configuration
  visibility_timeout_seconds = local.sqs_config.visibility_timeout_seconds
  message_retention_seconds  = local.sqs_config.message_retention_seconds
  receive_wait_time_seconds  = local.sqs_config.receive_wait_time_seconds

  # Encryption
  sqs_managed_sse_enabled = local.sqs_config.sqs_managed_sse_enabled

  # Dead letter queue
  create_dlq                    = local.sqs_config.create_dlq
  dlq_message_retention_seconds = local.sqs_config.dlq_message_retention_seconds
  redrive_max_receive_count     = local.sqs_config.redrive_max_receive_count

  tags = local.tags
}
