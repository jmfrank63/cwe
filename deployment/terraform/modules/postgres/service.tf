resource "kubernetes_service" "postgres" {
  metadata {
    name = "pgdb"
  }
  spec {
    selector = {
      app = "postgres"
    }
    port {
      name = "postgres"
      port        = 5432
      target_port = 5432
    }
  }
}

output "service_name" {
  value = kubernetes_service.postgres.metadata[0].name
}
