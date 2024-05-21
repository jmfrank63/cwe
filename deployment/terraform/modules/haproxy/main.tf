resource "kubernetes_secret" "haproxy_certs" {
  metadata {
    name = "haproxy-certs"
  }
  data = {
    "admin.pem" = filebase64("/home/johannes/.local/ssl/certs/cwe/admin.pem")
  }
}

resource "kubernetes_deployment" "haproxy" {
  metadata {
    name = "haproxy"
  }
  spec {
    replicas = 1
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
          image = "haproxy"
          name  = "haproxy"
          port {
            container_port = 443
          }
          port {
            container_port = 8444
          }
          volume_mount {
            mount_path = "/usr/local/etc/haproxy/certs"
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
              key  = "haproxy_cfg"
              path = "haproxy.cfg"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "haproxy" {
  metadata {
    name = "haproxy"
  }
  spec {
    selector = {
      app = "haproxy"
    }
    port {
      port        = 443
      target_port = 443
    }
    port {
      port        = 8444
      target_port = 8444
      name        = "admin"
    }
    type = "LoadBalancer"
  }
}

resource "null_resource" "haproxy_config" {
  provisioner "local-exec" {
    command = "kubectl create configmap haproxy-config --from-file=/home/johannes/Projects/Rust/cwe/haproxy/haproxy.cfg --dry-run=client -o yaml | kubectl apply -f -"
  }
}
