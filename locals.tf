# =============================================================================
# LOCALS.TF - Configuration Loading & Computed Values
# =============================================================================
# Loads config.yaml and provides computed values for all modules
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # LOAD SINGLE SOURCE OF TRUTH
  # ---------------------------------------------------------------------------
  config = yamldecode(file("${path.root}/config.yaml"))

  # ---------------------------------------------------------------------------
  # SELECT ENVIRONMENT CONFIGURATION
  # ---------------------------------------------------------------------------
  env = local.config.environments[var.environment]

  # ---------------------------------------------------------------------------
  # COMPUTED VALUES
  # ---------------------------------------------------------------------------
  project_name = local.config.project_name
  name_prefix  = "${local.config.project_name}-${var.environment}"
  aws_region   = local.env.aws_region

  # ---------------------------------------------------------------------------
  # MERGED TAGS
  # ---------------------------------------------------------------------------
  # Combines common tags + environment-specific compliance tags
  tags = merge(
    local.config.common_tags,
    local.env.compliance_tags,
    {
      Environment = var.environment
      TenantType  = local.env.tenant_type
      Region      = local.env.aws_region
    }
  )

  # ---------------------------------------------------------------------------
  # VPC CONFIGURATION
  # ---------------------------------------------------------------------------
  vpc_config = local.env.vpc

  # ---------------------------------------------------------------------------
  # EKS CONFIGURATION
  # ---------------------------------------------------------------------------
  eks_config = local.env.eks

  # ---------------------------------------------------------------------------
  # RDS CONFIGURATION
  # ---------------------------------------------------------------------------
  rds_config = local.env.rds

  # ---------------------------------------------------------------------------
  # SQS CONFIGURATION
  # ---------------------------------------------------------------------------
  sqs_config = local.env.sqs
  sqs_queues = toset(local.sqs_config.queues)
}
