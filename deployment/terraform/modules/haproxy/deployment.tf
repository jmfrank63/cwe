resource "kubernetes_deployment" "haproxy" {
  metadata {
    name = "haproxy"
  }
  spec {
    replicas                  = 1
    progress_deadline_seconds = 120
    selector {
      match_labels = {
        app = "haproxy"
      }
    }
    template {
      metadata {
        labels = {
          app = "haproxy"
        }
      }
      spec {
        container {
          image = "ghcr.io/jmfrank63/cwe-haproxy:latest"
          name  = "haproxy"
          port {
            container_port = 443
          }
          port {
            container_port = 8444
          }

          resources {
            requests = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }

          volume_mount {
            mount_path = "/etc/ssl/private/admin.pem"
            sub_path   = "admin.pem"
            name       = "haproxy-certs"
          }

          volume_mount {
            mount_path = "/usr/local/etc/haproxy/haproxy.cfg"
            sub_path   = "haproxy.cfg"
            name       = "haproxy-config"
          }
        }

        volume {
          name = "haproxy-certs"
          secret {
            secret_name = kubernetes_secret.haproxy_certs.metadata.0.name
          }
        }

        volume {
          name = "haproxy-config"
          config_map {
            name = kubernetes_config_map.haproxy_config.metadata.0.name
            items {
              key  = "haproxy.cfg"
              path = "haproxy.cfg"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_config_map.haproxy_config, kubernetes_secret.haproxy_certs,
  ]
}
