variable "release_name" {
  description = "Helm release name for HashiCorp Vault."
  type        = string
  default     = "vault"
}

variable "namespace" {
  description = "Kubernetes namespace where Vault will be installed."
  type        = string
  default     = "vault"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "chart_version" {
  description = "Version of the official HashiCorp Vault Helm chart."
  type        = string

  validation {
    condition     = length(trimspace(var.chart_version)) > 0
    error_message = "The Vault Helm chart version must not be empty."
  }
}

variable "vault_image_tag" {
  description = "Vault container image version."
  type        = string
}

variable "storage_size" {
  description = "Persistent volume size for Vault."
  type        = string
  default     = "10Gi"
}

variable "storage_class" {
  description = "Kubernetes StorageClass for Vault persistent storage. Empty uses the cluster default."
  type        = string
  default     = ""
}

variable "injector_enabled" {
  description = "Whether to enable the Vault Agent Injector."
  type        = bool
  default     = true
}

variable "ui_enabled" {
  description = "Whether to enable the Vault UI."
  type        = bool
  default     = true
}

variable "cpu_request" {
  description = "CPU resource request for Vault."
  type        = string
  default     = "250m"
}

variable "memory_request" {
  description = "Memory resource request for Vault."
  type        = string
  default     = "256Mi"
}

variable "cpu_limit" {
  description = "CPU resource limit for Vault."
  type        = string
  default     = "1000m"
}

variable "memory_limit" {
  description = "Memory resource limit for Vault."
  type        = string
  default     = "1Gi"
}