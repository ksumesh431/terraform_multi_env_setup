# =============================================================================
# RDS MODULE - MAIN
# =============================================================================
# Uses the official AWS RDS Terraform module
# Source: https://registry.terraform.io/modules/terraform-aws-modules/rds/aws
# =============================================================================

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.4.0"

  identifier = var.identifier

  # Engine configuration
  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family
  major_engine_version = var.major_engine_version
  instance_class       = var.instance_class

  # Storage
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted

  # Database settings
  db_name  = var.db_name
  username = var.db_username
  port     = var.db_port

  # Automated password management via Secrets Manager
  manage_master_user_password = true

  # High availability
  multi_az = var.multi_az

  # Network
  db_subnet_group_name   = var.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # Subnet group (use existing from VPC)
  create_db_subnet_group = false

  # Backup configuration
  backup_retention_period          = var.backup_retention_period
  backup_window                    = var.backup_window
  maintenance_window               = var.maintenance_window
  skip_final_snapshot              = var.skip_final_snapshot
  final_snapshot_identifier_prefix = "${var.identifier}-final"

  # Deletion protection
  deletion_protection = var.deletion_protection

  # Performance insights
  performance_insights_enabled = var.performance_insights_enabled

  # Monitoring
  monitoring_interval    = var.monitoring_interval
  create_monitoring_role = var.monitoring_interval > 0 ? true : false
  monitoring_role_name   = var.monitoring_interval > 0 ? "${var.identifier}-rds-monitoring" : null

  # Parameter group
  parameter_group_name      = "${var.identifier}-${var.family}"
  create_db_parameter_group = true
  parameters                = var.parameters

  # Tags
  tags = merge(
    var.tags,
    {
      Component = "database"
    }
  )
}

# -----------------------------------------------------------------------------
# RDS SECURITY GROUP
# -----------------------------------------------------------------------------

resource "aws_security_group" "rds" {
  name_prefix = "${var.identifier}-rds-"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name      = "${var.identifier}-rds-sg"
      Component = "database"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Allow ingress from private subnets (where EKS nodes run)
resource "aws_security_group_rule" "rds_ingress" {
  security_group_id = aws_security_group.rds.id
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  cidr_blocks       = var.private_subnets_cidr
  description       = "PostgreSQL access from private subnets"
}

# Allow egress
resource "aws_security_group_rule" "rds_egress" {
  security_group_id = aws_security_group.rds.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all egress"
}
