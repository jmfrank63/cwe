resource "kubernetes_service" "web_server" {
  metadata {
    name = "web-server"
  }
  spec {
    selector = {
      app = "web-server"
    }
    port {
      name = "alt-https"
      port        = 8443
      target_port = 8443
    }
  }
}
