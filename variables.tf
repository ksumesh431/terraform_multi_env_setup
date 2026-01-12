# =============================================================================
# VARIABLES.TF - Input Variables
# =============================================================================

variable "environment" {
  description = "Environment to deploy (must match a key in config.yaml environments)"
  type        = string

  validation {
    condition     = contains(["us", "eu", "single-tenant-acme"], var.environment)
    error_message = "Valid environments: us, eu, single-tenant-acme. Add new environments to config.yaml and update this validation."
  }
}
