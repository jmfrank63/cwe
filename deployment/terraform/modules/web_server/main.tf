resource "kubernetes_secret" "web_server_certs" {
  metadata {
    name = "web-server-certs"
  }
  data = {
    "cwe.crt" = file("${path.module}/../../../../haproxy/cwe.crt")
    "cwe.key" = file("${path.module}/../../../../haproxy/cwe.key")
  }
}

resource "kubernetes_deployment" "web_server" {
  metadata {
    name = "web-server"
  }
  spec {
    replicas = 2
    progress_deadline_seconds = 300
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
            secret_name = kubernetes_secret.web_server_certs.metadata[0].name
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
