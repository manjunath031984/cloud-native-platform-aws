resource "kubernetes_namespace_v1" "vault" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/name"       = "vault"
      "app.kubernetes.io/managed-by" = "terraform"
      "environment"                  = var.environment
    }
  }
}

resource "helm_release" "vault" {
  name       = var.release_name
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = var.chart_version
  namespace  = kubernetes_namespace_v1.vault.metadata[0].name

  atomic  = true
  timeout = 600

  values = [
    yamlencode({
      global = {
        enabled    = true
        tlsDisable = true
      }

      injector = {
        enabled = var.injector_enabled
      }

      server = {
        enabled = true

        image = {
          repository = "hashicorp/vault"
          tag        = var.vault_image_tag
        }

        standalone = {
          enabled = true

          config = <<-EOT
            ui = ${var.ui_enabled ? "true" : "false"}

            listener "tcp" {
              address         = "[::]:8200"
              cluster_address = "[::]:8201"
              tls_disable     = 1
            }

            storage "file" {
              path = "/vault/data"
            }
          EOT
        }

        dataStorage = {
          enabled      = true
          size         = var.storage_size
          storageClass = var.storage_class != "" ? var.storage_class : null
          accessMode   = "ReadWriteOnce"
        }

        service = {
          enabled = true
          type    = "ClusterIP"
        }

        resources = {
          requests = {
            cpu    = var.cpu_request
            memory = var.memory_request
          }

          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
        }
      }

      ui = {
        enabled = var.ui_enabled

        service = {
          enabled = true
          type    = "ClusterIP"
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.vault
  ]
}