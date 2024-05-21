resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
  }
  spec {
    replicas                  = 1
    progress_deadline_seconds = 120
    selector {
      match_labels = {
        app = "postgres"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }
      spec {
        container {
          image = "ghcr.io/jmfrank63/cwe-db:latest"
          name  = "postgres"
          port {
            container_port = 5432
          }
          resources {
            requests = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }
          env_from {
            config_map_ref {
              name = "postgres-env"
            }
          }

          env {
            name = "POSTGRES_DB"
            value_from {
              config_map_key_ref {
                name = "postgres-env"
                key  = "POSTGRES_DB"
              }
            }
          }
          env {
            name = "POSTGRES_USER"
            value_from {
              config_map_key_ref {
                name = "postgres-env"
                key  = "POSTGRES_USER"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              config_map_key_ref {
                name = "postgres-env"
                key  = "POSTGRES_PASSWORD"
              }
            }
          }

          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "pgdata"
          }

          volume_mount {
            mount_path = "/etc/ssl/private"
            name       = "ssl-certs"
            read_only  = true
          }

          volume_mount {
            mount_path = "/etc/postgresql/postgresql.conf"
            name       = "postgresql-conf"
            sub_path   = "postgresql.conf"
          }
        }

        volume {
          name = "pgdata"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata.0.name
          }
        }

        volume {
          name = "ssl-certs"
          secret {
            secret_name = kubernetes_secret.postgres_ssl_certs.metadata[0].name
          }
        }

        volume {
          name = "postgresql-conf"
          config_map {
            name = kubernetes_config_map.postgres_config.metadata[0].name
          }
        }
      }
    }
  }
  depends_on = [null_resource.manage_configmap,
    kubernetes_persistent_volume_claim.postgres_pvc,
  kubernetes_secret.postgres_ssl_certs]
}
