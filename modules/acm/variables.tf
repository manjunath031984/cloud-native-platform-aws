# ============================================================
# General Configuration
# ============================================================

variable "name" {
  description = "Name prefix for ACM resources."
  type        = string
}

variable "tags" {
  description = "Tags applied to ACM resources."
  type        = map(string)
  default     = {}
}

# ============================================================
# Certificate Domain Configuration
# ============================================================

variable "domain_name" {
  description = "Primary domain name for the ACM certificate."
  type        = string
  default     = "cloudaiops.site"

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "The primary domain name must not be empty."
  }
}

variable "subject_alternative_names" {
  description = "Additional domain names covered by the ACM certificate."
  type        = list(string)
  default     = ["www.cloudaiops.site"]
}