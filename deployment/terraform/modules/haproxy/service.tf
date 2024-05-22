resource "kubernetes_service" "haproxy" {
  metadata {
    name = "haproxy"
  }
  spec {
    selector = {
      app = "haproxy"
    }
    port {
      name        = "https"
      port        = 443
      target_port = 443
    }
    port {
      name        = "admin"
      port        = 8444
      target_port = 8444

    }
    type = "LoadBalancer"
    cluster_ip = "10.96.1.254"
  }
}
