resource "kubernetes_horizontal_pod_autoscaler_v2" "web_server_hpa" {
  metadata {
    name = "web-server-hpa"
  }
  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "web-server"
    }
    min_replicas = 2
    max_replicas = 10
    metric {
      type = "ContainerResource"
      container_resource {
        name      = "cpu"
        container = "web-server"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }

    behavior {
      scale_down {
        stabilization_window_seconds = 10
        select_policy = "Max"
        policy {
          type           = "Pods"
          value          = 1
          period_seconds = 10
        }
        policy {
          type           = "Percent"
          value          = 10
          period_seconds = 10
        }
      }
      scale_up {
        stabilization_window_seconds = 0
        select_policy = "Max"
        policy {
          type           = "Pods"
          value          = 4
          period_seconds = 30
        }
        policy {
          type           = "Percent"
          value          = 100
          period_seconds = 30
        }
      }
    }

  }
}
