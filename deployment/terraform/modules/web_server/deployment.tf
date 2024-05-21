resource "kubernetes_deployment" "web_server" {
  metadata {
    name = "web-server"
  }
  spec {
    replicas                  = 2
    progress_deadline_seconds = 120
    selector {
      match_labels = {
        app = "web-server"
      }
    }
    template {
      metadata {
        labels = {
          app = "web-server"
        }
      }
      spec {
        container {
          image = "ghcr.io/jmfrank63/cwe-server:latest"
          name  = "web-server"
          port {
            container_port = 8443
          }

          resources {
            requests = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }
          
          env_from {
            config_map_ref {
              name = "web-server-env"
            }
          }

          volume_mount {
            name       = "ssl-cert"
            mount_path = "/ssl/private/server.crt"
            sub_path   = "server.crt"
            read_only  = true
          }

          volume_mount {
            name       = "ssl-key"
            mount_path = "/ssl/private/server.key"
            sub_path   = "server.key"
            read_only  = true
          }

          volume_mount {
            name       = "env-file"
            mount_path = "/usr/src/app/.env"
            sub_path   = ".env"
            read_only  = true
          }
        }

        volume {
          name = "ssl-cert"
          secret {
            secret_name = kubernetes_secret.web_server_certs.metadata[0].name
          }
        }

        volume {
          name = "ssl-key"
          secret {
            secret_name = kubernetes_secret.web_server_certs.metadata[0].name
          }
        }

        volume {
          name = "env-file"
          config_map {
            name = kubernetes_config_map.web_server_env_file.metadata[0].name
          }
        }
      }
    }
  }
  depends_on = [kubernetes_secret.web_server_certs,
    kubernetes_config_map.web_server_env_file,
  null_resource.manage_configmap]
}
