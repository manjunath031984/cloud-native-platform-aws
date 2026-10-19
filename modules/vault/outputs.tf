output "namespace" {
  description = "Kubernetes namespace where Vault is installed."
  value       = kubernetes_namespace_v1.vault.metadata[0].name
}

output "release_name" {
  description = "Vault Helm release name."
  value       = helm_release.vault.name
}

output "release_status" {
  description = "Deployment status of the Vault Helm release."
  value       = helm_release.vault.status
}

output "chart_version" {
  description = "Installed Vault Helm chart version."
  value       = helm_release.vault.version
}

output "service_name" {
  description = "Internal Kubernetes service name for Vault."
  value       = "${var.release_name}-active"
}

output "internal_address" {
  description = "Internal Vault API address for in-cluster clients."
  value       = "http://${var.release_name}-active.${var.namespace}.svc:8200"
}

output "ui_enabled" {
  description = "Whether the Vault UI is enabled."
  value       = var.ui_enabled
}