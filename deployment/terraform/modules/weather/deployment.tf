resource "kubernetes_deployment" "weather" {
  metadata {
    name = "weather"
  }
  spec {
    replicas                  = 2
    progress_deadline_seconds = 180
    selector {
      match_labels = {
        app = "weather"
      }
    }
    template {
      metadata {
        labels = {
          app = "weather"
        }
      }
      spec {
        container {
          image = "ghcr.io/jmfrank63/cwe-weather:latest"
          name  = "weather"
          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }

          env_from {
            config_map_ref {
              name = "weather-env"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_config_map.weather_env]
}
