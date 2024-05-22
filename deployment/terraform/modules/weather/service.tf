resource "kubernetes_service" "weather" {
  metadata {
    name = "weather"
  }
  spec {
    selector = {
      app = "weather"
    }
    port {
      name = "http"
      port        = 8080
      target_port = 8080
    }
  }
}
