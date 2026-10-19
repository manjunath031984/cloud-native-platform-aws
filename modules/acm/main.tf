# ============================================================
# AWS Certificate Manager - Public SSL/TLS Certificate
# ============================================================

resource "aws_acm_certificate" "this" {
  domain_name = var.domain_name

  subject_alternative_names = var.subject_alternative_names

  validation_method = "DNS"

  key_algorithm = "RSA_2048"

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-acm"
      Component = "acm"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}