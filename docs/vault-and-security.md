# Secrets Management and Security

## HashiCorp Vault

Vault is the planned centralized secrets-management platform for application secrets, tokens, database credentials, and supported dynamic secrets.

Before deploying Vault, document:
- Self-hosted versus managed deployment
- Storage backend, durability, and high availability
- Initialization and unsealing
- Authentication for CI and Kubernetes workloads
- Least-privilege policies
- Rotation and revocation
- Backup, restore, and disaster recovery
- Bootstrap dependencies and operational ownership

## AWS Encryption

Vault is **not a universal replacement for AWS KMS**. Use Vault for secrets management, and retain AWS-managed encryption or KMS where required or appropriate for AWS services, S3, Terraform state, EKS secrets encryption, and backup encryption.

## Terraform State

- Use a protected S3 backend.
- Enable versioning and encryption.
- Block public access and apply restrictive IAM policies.
- Use native S3 state locking supported by the selected Terraform version.
- Do not commit state files or credentials.
- Avoid passing secret values through Terraform when runtime retrieval is practical.

## Kubernetes Workload Identity

The diagram shows EKS IAM OIDC and IRSA. Use narrowly scoped IAM roles for workloads that need AWS API access. Avoid static AWS keys in pods.
