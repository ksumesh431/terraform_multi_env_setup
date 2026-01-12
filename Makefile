# =============================================================================
# MAKEFILE - Terraform Automation
# =============================================================================
# Usage:
#   make ENV=us init     - Initialize terraform for US environment
#   make ENV=eu plan     - Plan EU environment
#   make ENV=us apply    - Apply US environment
#   make ENV=us tf CMD="state list"  - Run any terraform command
# =============================================================================

# Default environment
ENV ?= us

# Validate environment
VALID_ENVS := us eu single-tenant-acme
$(if $(filter $(ENV),$(VALID_ENVS)),,$(error Invalid ENV=$(ENV). Valid: $(VALID_ENVS)))

# Terraform arguments
TF_ARGS := -var="environment=$(ENV)"

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# =============================================================================
# TERRAFORM COMMANDS
# =============================================================================

.PHONY: init plan apply destroy validate fmt output console refresh show graph clean tf help

## Initialize Terraform for the specified environment
init:
	@echo "$(GREEN)Initializing Terraform for environment: $(ENV)$(NC)"
	terraform init -backend-config="key=$(ENV)/terraform.tfstate" -reconfigure

## Run Terraform plan
plan:
	@echo "$(GREEN)Planning environment: $(ENV)$(NC)"
	terraform plan $(TF_ARGS)

## Run Terraform plan and save to file
plan-out:
	@echo "$(GREEN)Planning environment: $(ENV) -> $(ENV).tfplan$(NC)"
	terraform plan $(TF_ARGS) -out=$(ENV).tfplan

## Apply Terraform changes (with confirmation)
apply:
	@echo "$(YELLOW)Applying environment: $(ENV)$(NC)"
	terraform apply $(TF_ARGS)

## Apply Terraform changes (auto-approve - use with caution)
apply-auto:
	@echo "$(RED)Auto-applying environment: $(ENV)$(NC)"
	terraform apply $(TF_ARGS) -auto-approve

## Apply saved plan
apply-plan:
	@echo "$(YELLOW)Applying saved plan: $(ENV).tfplan$(NC)"
	terraform apply $(ENV).tfplan

## Destroy infrastructure (with confirmation)
destroy:
	@echo "$(RED)Destroying environment: $(ENV)$(NC)"
	terraform destroy $(TF_ARGS)

## Validate Terraform configuration
validate:
	@echo "$(GREEN)Validating configuration$(NC)"
	terraform validate

## Format Terraform files
fmt:
	@echo "$(GREEN)Formatting Terraform files$(NC)"
	terraform fmt -recursive

## Check formatting
fmt-check:
	@echo "$(GREEN)Checking Terraform formatting$(NC)"
	terraform fmt -check -recursive

## Show outputs
output:
	@echo "$(GREEN)Outputs for environment: $(ENV)$(NC)"
	terraform output

## Open Terraform console
console:
	@echo "$(GREEN)Opening console for environment: $(ENV)$(NC)"
	terraform console $(TF_ARGS)

## Refresh state
refresh:
	@echo "$(GREEN)Refreshing state for environment: $(ENV)$(NC)"
	terraform refresh $(TF_ARGS)

## Show current state
show:
	@echo "$(GREEN)Showing state$(NC)"
	terraform show

## List resources in state
state-list:
	@echo "$(GREEN)Listing state for environment: $(ENV)$(NC)"
	terraform state list

## Generate dependency graph
graph:
	@echo "$(GREEN)Generating dependency graph$(NC)"
	terraform graph | dot -Tpng > $(ENV)-graph.png
	@echo "Graph saved to $(ENV)-graph.png"

## Clean generated files
clean:
	@echo "$(YELLOW)Cleaning generated files$(NC)"
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f *.tfplan
	rm -f *-graph.png

# =============================================================================
# CATCH-ALL FOR ANY TERRAFORM COMMAND
# =============================================================================

## Run any terraform command: make ENV=us tf CMD="state show module.vpc"
tf:
	@echo "$(GREEN)Running: terraform $(CMD) for environment: $(ENV)$(NC)"
	terraform $(CMD) $(TF_ARGS)

# =============================================================================
# HELP
# =============================================================================

## Show this help
help:
	@echo "$(GREEN)Terraform Multi-Environment Makefile$(NC)"
	@echo ""
	@echo "Usage: make ENV=<environment> <target>"
	@echo ""
	@echo "Valid environments: $(VALID_ENVS)"
	@echo ""
	@echo "Targets:"
	@echo "  init        - Initialize Terraform backend for environment"
	@echo "  plan        - Plan infrastructure changes"
	@echo "  plan-out    - Plan and save to file (ENV.tfplan)"
	@echo "  apply       - Apply changes (with confirmation)"
	@echo "  apply-auto  - Apply changes (auto-approve)"
	@echo "  apply-plan  - Apply saved plan file"
	@echo "  destroy     - Destroy infrastructure"
	@echo "  validate    - Validate configuration"
	@echo "  fmt         - Format Terraform files"
	@echo "  fmt-check   - Check formatting"
	@echo "  output      - Show outputs"
	@echo "  console     - Open Terraform console"
	@echo "  refresh     - Refresh state"
	@echo "  show        - Show current state"
	@echo "  state-list  - List resources in state"
	@echo "  graph       - Generate dependency graph"
	@echo "  clean       - Remove generated files"
	@echo "  tf          - Run any terraform command (use CMD=)"
	@echo "  help        - Show this help"
	@echo ""
	@echo "Examples:"
	@echo "  make ENV=us init"
	@echo "  make ENV=eu plan"
	@echo "  make ENV=single-tenant-acme apply"
	@echo "  make ENV=us tf CMD=\"state list\""
	@echo "  make ENV=eu tf CMD=\"import module.vpc.aws_vpc.this vpc-xxxxx\""
