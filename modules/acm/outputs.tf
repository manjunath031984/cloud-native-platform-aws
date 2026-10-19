# ============================================================
# ACM Certificate Outputs
# ============================================================

output "certificate_arn" {
  description = "ARN of the ACM public certificate."
  value       = aws_acm_certificate.this.arn
}

output "certificate_domain_name" {
  description = "Primary domain name covered by the certificate."
  value       = aws_acm_certificate.this.domain_name
}

output "certificate_status" {
  description = "Current status of the ACM certificate."
  value       = aws_acm_certificate.this.status
}

output "certificate_validation_method" {
  description = "Validation method used by the certificate."
  value       = aws_acm_certificate.this.validation_method
}

# ============================================================
# DNS Validation Records
# ============================================================

output "certificate_domain_validation_options" {
  description = "DNS records required to validate the ACM certificate."

  value = [
    for option in aws_acm_certificate.this.domain_validation_options : {
      domain_name           = option.domain_name
      resource_record_name  = option.resource_record_name
      resource_record_type  = option.resource_record_type
      resource_record_value = option.resource_record_value
    }
  ]
}