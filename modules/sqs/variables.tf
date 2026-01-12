# =============================================================================
# SQS MODULE - VARIABLES
# =============================================================================

variable "name" {
  description = "Full name of the SQS queue"
  type        = string
}

variable "queue_name" {
  description = "Base queue name (without environment prefix)"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# -----------------------------------------------------------------------------
# QUEUE CONFIGURATION
# -----------------------------------------------------------------------------

variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "Message retention period in seconds"
  type        = number
  default     = 1209600 # 14 days
}

variable "receive_wait_time_seconds" {
  description = "Long polling wait time in seconds"
  type        = number
  default     = 10
}

# -----------------------------------------------------------------------------
# ENCRYPTION
# -----------------------------------------------------------------------------

variable "sqs_managed_sse_enabled" {
  description = "Enable SQS-managed server-side encryption"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# DEAD LETTER QUEUE
# -----------------------------------------------------------------------------

variable "create_dlq" {
  description = "Create a dead letter queue"
  type        = bool
  default     = false
}

variable "dlq_message_retention_seconds" {
  description = "Message retention for DLQ in seconds"
  type        = number
  default     = 1209600 # 14 days
}

variable "redrive_max_receive_count" {
  description = "Max receive count before sending to DLQ"
  type        = number
  default     = 3
}

# -----------------------------------------------------------------------------
# TAGS
# -----------------------------------------------------------------------------

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
