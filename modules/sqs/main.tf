# =============================================================================
# SQS MODULE - MAIN
# =============================================================================
# Uses the official AWS SQS Terraform module
# Source: https://registry.terraform.io/modules/terraform-aws-modules/sqs/aws
# =============================================================================

module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "4.1.1"

  name = var.name

  # Queue configuration
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  # Enable server-side encryption (SSE)
  sqs_managed_sse_enabled = var.sqs_managed_sse_enabled

  # Tags
  tags = merge(
    var.tags,
    {
      Component = "messaging"
      QueueName = var.queue_name
    }
  )
}

# -----------------------------------------------------------------------------
# DEAD LETTER QUEUE (Optional)
# -----------------------------------------------------------------------------

module "dlq" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "4.1.1"

  count = var.create_dlq ? 1 : 0

  name = "${var.name}-dlq"

  # DLQ configuration
  message_retention_seconds = var.dlq_message_retention_seconds
  sqs_managed_sse_enabled   = var.sqs_managed_sse_enabled

  # Tags
  tags = merge(
    var.tags,
    {
      Component = "messaging"
      QueueName = "${var.queue_name}-dlq"
      Type      = "dead-letter-queue"
    }
  )
}

# Configure redrive policy on main queue (if DLQ enabled)
resource "aws_sqs_queue_redrive_policy" "main" {
  count = var.create_dlq ? 1 : 0

  queue_url = module.sqs.queue_url

  redrive_policy = jsonencode({
    deadLetterTargetArn = module.dlq[0].queue_arn
    maxReceiveCount     = var.redrive_max_receive_count
  })
}
