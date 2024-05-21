provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = "default"
  }
}

resource "kubernetes_config_map" "postgres_config" {
  metadata {
    name = "postgres-config"
  }
  data = {
    POSTGRES_DB       = "pgdb"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }
}

resource "kubernetes_secret" "web_server_certs" {
  metadata {
    name = "web-server-certs"
  }
  data = {
    "cwe.crt" = file("/home/johannes/.local/ssl/certs/cwe/cwe.crt")
    "cwe.key" = file("/home/johannes/.local/ssl/certs/cwe/cwe.key")
  }
}

resource "kubernetes_secret" "haproxy_certs" {
  metadata {
    name = "haproxy-certs"
  }
  data = {
    "admin.pem" = file("/home/johannes/.local/ssl/certs/cwe/admin.pem")
  }
}

resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name = "pgdata-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
  }
  spec {
    replicas = 1
    progress_deadline_seconds = 180
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
          image = "postgres:latest"
          name  = "postgres"
          port {
            container_port = 5432
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map.postgres_config.metadata.0.name
            }
          }
          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "pgdata"
          }
        }
        volume {
          name = "pgdata"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres"
  }
  spec {
    selector = {
      app = "postgres"
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_deployment" "web_server" {
  metadata {
    name = "web-server"
  }
  spec {
    replicas = 2
    progress_deadline_seconds = 180
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
          image = "cwe-server"
          name  = "web-server"
          port {
            container_port = 8443
          }
          volume_mount {
            mount_path = "/ssl/private"
            name       = "ssl-certs"
          }
        }
        volume {
          name = "ssl-certs"
          secret {
            secret_name = kubernetes_secret.web_server_certs.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "web_server" {
  metadata {
    name = "web-server"
  }
  spec {
    selector = {
      app = "web-server"
    }
    port {
      port        = 8443
      target_port = 8443
    }
  }
}

resource "kubernetes_deployment" "haproxy" {
  metadata {
    name = "haproxy"
  }
  spec {
    replicas = 1
    progress_deadline_seconds = 180
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

resource "kubernetes_config_map" "haproxy_config" {
  metadata {
    name = "haproxy-config"
  }
  data = {
    haproxy_cfg = file("${path.module}/haproxy.cfg")
  }
}
