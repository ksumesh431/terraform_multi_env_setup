# =============================================================================
# BACKEND.TF - Remote State Configuration
# =============================================================================
# S3 backend with native S3 locking (Terraform 1.10+, no DynamoDB needed)
#
# IMPORTANT: Before enabling, create the S3 bucket with versioning:
#   aws s3 mb s3://sei-platform-terraform-state --region us-east-1
#   aws s3api put-bucket-versioning --bucket sei-platform-terraform-state \
#     --versioning-configuration Status=Enabled
#
# Each environment gets its own state file via -backend-config="key=ENV/terraform.tfstate"
# =============================================================================

terraform {
  backend "s3" {
    bucket = "sei-platform-terraform-state-makefile-unique-12345"
    # key is set dynamically via: terraform init -backend-config="key=ENV/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

# =============================================================================
# ALTERNATIVE: Local Backend (for development/testing)
# =============================================================================
# Uncomment below and comment out the S3 backend above for local development.
# State will be stored in ./terraform.tfstate
#
# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }
