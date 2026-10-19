# ============================================================
# Application Load Balancer Outputs
# ============================================================

output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = module.alb.alb_id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "alb_name" {
  description = "Name of the Application Load Balancer"
  value       = module.alb.alb_name
}

output "alb_dns_name" {
  description = "DNS name assigned to the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer"
  value       = module.alb.alb_zone_id
}

# ============================================================
# Application Load Balancer Target Group Outputs
# ============================================================

output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.alb.target_group_arn
}

output "alb_target_group_name" {
  description = "Name of the ALB target group"
  value       = module.alb.target_group_name
}

# ============================================================
# Application Load Balancer Listener Outputs
# ============================================================

output "alb_http_listener_arn" {
  description = "ARN of the ALB HTTP listener"
  value       = module.alb.http_listener_arn
}

output "alb_http_url" {
  description = "HTTP URL for accessing the Application Load Balancer"
  value       = module.alb.http_url
}
# ============================================================
# ACM Certificate Outputs
# ============================================================

output "acm_certificate_arn" {
  description = "ARN of the ACM public certificate."
  value       = module.acm.certificate_arn
}

output "acm_certificate_domain_name" {
  description = "Primary domain name covered by the certificate."
  value       = module.acm.certificate_domain_name
}

output "acm_certificate_status" {
  description = "Current status of the ACM certificate."
  value       = module.acm.certificate_status
}

output "acm_certificate_validation_records" {
  description = "DNS records required for ACM certificate validation."
  value       = module.acm.certificate_domain_validation_options
}
