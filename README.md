# Multi-Tenant Infrastructure (Pure Terraform)

A multi-tenant infrastructure platform built with **pure Terraform** using a **YAML configuration** as the single source of truth.

## Features

- 🏗️ **Multi-tenant architecture** with regional isolation (US, EU)
- 🇪🇺 **GDPR/CCPA compliant** EU deployment with data residency guarantees
- 🔒 **Single-tenant support** for enterprise customers (fully isolated VPC/EKS/RDS)
- 📦 **Container-first** using EKS for workload portability
- 🗃️ **Standard PostgreSQL** for database portability
- 🔧 **Single source of truth** (`config.yaml`) for all configurations
- 🛠️ **Makefile automation** for simplified Terraform workflows

---

## Architecture Overview

```
+-------------------------------------------------------------------------+
|                         GLOBAL CONFIGURATION                            |
|                           (config.yaml)                                 |
+------------------------------------+------------------------------------+
                                     |
         +--------------------------++--------------------------+
         |                          |                           |
         v                          v                           v
+----------------+        +----------------+        +-----------------------+
|   US REGION    |        |   EU REGION    |        |    SINGLE-TENANT      |
|   (us-east-1)  |        |   (eu-west-1)  |        |    (per customer)     |
|                |        |                |        |                       |
|  Multi-tenant  |        |  GDPR Isolated |        |  Fully Isolated Stack |
|  Shared Infra  |        |  No data exits |        |  - Own VPC            |
+-------+--------+        +-------+--------+        |  - Own EKS            |
        |                         |                 |  - Own RDS            |
        v                         v                 +-----------------------+
+-------------------------------------+
|  Per-Environment Resources:         |
|  - VPC (3 AZs, public/private/DB)   |
|  - EKS Cluster (managed nodes)      |
|  - RDS PostgreSQL (encrypted)       |
|  - SQS Queues (SSE enabled)         |
+-------------------------------------+
```

---

## Directory Structure

```
terraform_multi_env/
├── config.yaml                # 🎯 SINGLE SOURCE OF TRUTH
├── main.tf                    # Root module orchestrator
├── variables.tf               # Environment variable
├── locals.tf                  # Config loading & computed values
├── outputs.tf                 # Top-level outputs
├── providers.tf               # AWS provider configuration
├── backend.tf                 # S3 remote state
├── Makefile                   # All terraform commands
├── .gitignore
├── README.md
│
└── modules/
    ├── vpc/                   # VPC (uses terraform-aws-modules/vpc)
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── eks/                   # EKS (self-managed module)
    │   ├── main.tf            # Cluster, KMS, OIDC
    │   ├── node_groups.tf     # Managed node groups
    │   ├── addons.tf          # EKS addons with IRSA
    │   ├── variables.tf
    │   └── outputs.tf
    ├── rds/                   # RDS PostgreSQL
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── sqs/                   # SQS Queues
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Quick Start

### Prerequisites

- [Terraform v1.5+](https://developer.hashicorp.com/terraform/install)
- AWS CLI configured with appropriate credentials
- Make (for Makefile commands)

### Create S3 Backend (First Time Only)

```bash
# Create the S3 bucket for remote state
aws s3 mb s3://sei-platform-terraform-state-makefile-unique-12345 --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket sei-platform-terraform-state \
  --versioning-configuration Status=Enabled
```
# Enable object locking
for state locking to work

### Deploy Infrastructure

```bash
# Initialize Terraform for US environment
make ENV=us init

# Preview changes
make ENV=us plan

# Apply changes
make ENV=us apply

# Show outputs
make ENV=us output
```

### Deploy Multiple Environments

```bash
# US Region (Multi-tenant)
make ENV=us init
make ENV=us apply

# EU Region (GDPR isolated)
make ENV=eu init
make ENV=eu apply

# Single-tenant customer (ACME Corp)
make ENV=single-tenant-acme init
make ENV=single-tenant-acme apply
```

---

## Makefile Commands

| Command | Description |
|---------|-------------|
| `make ENV=<env> init` | Initialize Terraform backend |
| `make ENV=<env> plan` | Preview infrastructure changes |
| `make ENV=<env> apply` | Apply changes (with confirmation) |
| `make ENV=<env> apply-auto` | Apply changes (auto-approve) |
| `make ENV=<env> destroy` | Destroy infrastructure |
| `make ENV=<env> output` | Show outputs |
| `make ENV=<env> validate` | Validate configuration |
| `make ENV=<env> fmt` | Format Terraform files |
| `make ENV=<env> console` | Open Terraform console |
| `make ENV=<env> state-list` | List resources in state |
| `make ENV=<env> tf CMD="..."` | Run any Terraform command |
| `make help` | Show all available commands |

### Examples

```bash
# Run any terraform command
make ENV=us tf CMD="state list"
make ENV=eu tf CMD="state show module.vpc"
make ENV=us tf CMD="import module.vpc.aws_vpc.this vpc-xxxxx"

# View dependency graph
make ENV=us graph
```

---

## Configuration

### Single Source of Truth: config.yaml

All environment configurations are stored in `config.yaml`. Modify this file to customize deployments:

```yaml
project_name: sei-platform

environments:
  us:
    aws_region: us-east-1
    is_gdpr_region: false
    vpc:
      cidr: "10.0.0.0/16"
      # ... all VPC settings
    eks:
      cluster_version: "1.31"
      # ... all EKS settings
    rds:
      instance_class: db.t3.large
      # ... all RDS settings
    sqs:
      queues: [orders, notifications, events]
      # ... all SQS settings

  eu:
    aws_region: eu-west-1
    is_gdpr_region: true
    # GDPR-specific settings (extended retention, compliance tags)

  single-tenant-acme:
    aws_region: us-east-1
    tenant_type: single-tenant
    # Cost-optimized settings for dedicated customer
```

### Adding a New Environment

1. Add the environment configuration to `config.yaml`
2. Update the validation in `variables.tf`
3. Run `make ENV=new-env init && make ENV=new-env apply`

### Adding a New Single-Tenant Customer

1. Copy an existing single-tenant configuration in `config.yaml`
2. Modify the customer-specific settings (VPC CIDR, tags, etc.)
3. Add the environment name to the validation list
4. Deploy: `make ENV=single-tenant-newcustomer init && apply`

---

## GDPR Compliance

The EU region includes additional security and compliance measures:

| Feature | US | EU (GDPR) |
|---------|-----|-----------|
| Cluster Log Retention | 90 days | 365 days |
| RDS Backup Retention | 7 days | 30 days |
| Compliance Tags | None | `Compliance=GDPR, DataResidency=EU` |


---

## Outputs

After deployment, view outputs with:

```bash
make ENV=us output
```

Key outputs include:
- `eks_cluster_endpoint` - EKS API server endpoint
- `eks_update_kubeconfig_command` - Command to configure kubectl
- `rds_endpoint` - PostgreSQL connection endpoint
- `rds_master_user_secret_arn` - Secrets Manager ARN for DB password
- `sqs_queue_urls` - Map of queue names to URLs

---

## Connect to EKS Cluster

```bash
# Get the kubeconfig command from outputs
make ENV=us output | grep eks_update_kubeconfig_command

# Run the command
aws eks update-kubeconfig --name sei-platform-us --region us-east-1

# Verify connection
kubectl get nodes
```

---

## Troubleshooting

### State Lock Issues

If Terraform state is locked:

```bash
# Check who has the lock
make ENV=us tf CMD="state list"

# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>
```

### Module Errors

```bash
# Reinitialize modules
make ENV=us init

# Upgrade modules
terraform init -upgrade
```

---

## CI/CD Integration

### Environment Variables

```bash
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx
export TF_INPUT=0  # Non-interactive mode
```

### Pipeline Example

```yaml
# GitHub Actions / GitLab CI
deploy-us:
  script:
    - make ENV=us init
    - make ENV=us plan
    - make ENV=us apply-auto
```

---

## Security Best Practices

- ✅ All storage encrypted (EBS, RDS, SQS SSE)
- ✅ KMS keys with rotation enabled
- ✅ IMDSv2 enforced on all EC2 instances
- ✅ Private subnets for EKS nodes and RDS
- ✅ Security groups with least-privilege access
- ✅ Secrets Manager for database credentials
- ✅ IRSA for EKS addon permissions
