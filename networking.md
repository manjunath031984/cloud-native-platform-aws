# AWS Networking Design

## Proposed Layout

- VPC: `10.0.0.0/16`
- Three Availability Zones
- Three public subnets and three private subnets
- Internet Gateway for public routing
- NAT Gateway per AZ as shown in the diagram; make this configurable for lower-cost development environments
- Amazon EKS worker nodes in private subnets
- AWS Network Load Balancer as the public entry point, with Traefik behind it

## Security Requirements

- Use least-privilege security group rules.
- Do not expose worker nodes or internal databases publicly.
- Prefer private EKS API access. If public access is enabled, use an explicit CIDR allowlist.
- Evaluate VPC endpoints for required AWS services.
- Document subnet CIDRs, route tables, NAT costs, endpoint choices, and availability assumptions before applying Terraform.

## DNS and TLS

The diagram shows GoDaddy registration, Route 53 nameserver delegation, a Route 53 alias, NLB, Traefik, cert-manager, and Let's Encrypt. Verify ownership and DNS delegation before making changes. Document whether TLS terminates at the NLB, Traefik, or both; do not assume the diagram's arrows settle this detail.
