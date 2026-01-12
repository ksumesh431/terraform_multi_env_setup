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
