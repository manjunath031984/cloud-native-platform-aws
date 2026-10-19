# Terraform VPC Module — Sydney, 2 AZs

Creates a VPC with two public subnets and two private subnets across two configured Availability Zones. Includes an Internet Gateway, route tables, optional NAT Gateway topology, EKS subnet discovery tags, and an optional S3 gateway endpoint.

## Example root configuration

```hcl
provider "aws" {
  region = "ap-southeast-2"
}

module "vpc" {
  source = "../../modules/vpc"

  name               = "cloud-native-platform-dev"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

  public_subnet_cidrs  = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnet_cidrs = ["10.0.32.0/20", "10.0.48.0/20"]

  nat_gateway_mode           = "single"
  enable_nat_gateway         = true
  enable_s3_gateway_endpoint = true

  tags = {
    Project     = "cloud-native-platform-aws"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

## NAT options

- `single`: one NAT Gateway in the first configured AZ; cheaper, but the other AZ depends on it and cross-AZ traffic may incur charges.
- `per_az`: one NAT Gateway in each AZ; improves AZ-level resilience but costs more.
- `enable_nat_gateway = false`: private subnets have no default internet route; ensure dependencies are reachable through endpoints or another approved route.

Before applying, confirm AZ availability, CIDR non-overlap, regional costs, and the complete Terraform plan. This module does not create EKS, Vault, DNS records, application security groups, or the remote state backend.
