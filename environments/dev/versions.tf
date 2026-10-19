# -----------------------------------------------------------------------------
# AWS Cloud-Native Platform
# Terraform and Provider Version Constraints
# -----------------------------------------------------------------------------

terraform {
  # Minimum required Terraform version
  required_version = ">= 1.6.0"

  # Required providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }
}
