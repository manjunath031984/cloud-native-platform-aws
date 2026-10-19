# ------------------------------------------------------------
# VPC Outputs
# ------------------------------------------------------------

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}


# ------------------------------------------------------------
# Subnet Outputs
# ------------------------------------------------------------

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of the private subnets"
  value       = aws_subnet.private[*].cidr_block
}


# ------------------------------------------------------------
# Internet Gateway Output
# ------------------------------------------------------------

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}


# ------------------------------------------------------------
# Route Table Outputs
# ------------------------------------------------------------

output "public_route_table_id" {
  description = "ID of the shared public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the shared private route table"
  value       = aws_route_table.private.id
}


# ------------------------------------------------------------
# NAT Gateway Outputs
# ------------------------------------------------------------

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_public_ips" {
  description = "Public IP addresses allocated to the NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}


# ------------------------------------------------------------
# S3 Gateway Endpoint Output
# ------------------------------------------------------------

output "s3_gateway_endpoint_id" {
  description = "ID of the S3 Gateway VPC Endpoint"
  value       = try(aws_vpc_endpoint.s3[0].id, null)
}
