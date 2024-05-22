# # Network Policy to allow traffic to the Metrics Server
# resource "kubernetes_network_policy" "allow_metrics_server" {
#   metadata {
#     name      = "allow-metrics-server"
#     namespace = "kube-system"
#   }
#   spec {
#     pod_selector {
#       match_labels = {
#         "k8s-app" = "metrics-server"
#       }
#     }
#     policy_types = ["Ingress"]
#     ingress {
#       from {
#         namespace_selector {
#           match_labels = {
#             name = "kube-system"
#           }
#         }
#       }
#       ports {
#         protocol = "TCP"
#         port     = 4443
#       }
#       ports {
#         protocol = "TCP"
#         port     = 10250
#       }
#     }
#   }
# }

# # Example Network Policies for HAProxy, Web Server, and PostgreSQL
# resource "kubernetes_network_policy" "allow_haproxy_web" {
#   metadata {
#     name      = "allow-haproxy-web"
#     namespace = "default"
#   }
#   spec {
#     pod_selector {
#       match_labels = {
#         app = "web-server"
#       }
#     }
#     ingress {
#       from {
#         pod_selector {
#           match_labels = {
#             app = "haproxy"
#           }
#         }
#       }
#       ports {
#         protocol = "TCP"
#         port     = 8443
#       }

#       ports {
#         protocol = "TCP"
#         port     = 10250
#       }

#     }
#     policy_types = ["Ingress"]
#   }
# }

# resource "kubernetes_network_policy" "allow_haproxy_weather" {
#   metadata {
#     name      = "allow-haproxy-weather"
#     namespace = "default"
#   }
#   spec {
#     pod_selector {
#       match_labels = {
#         app = "weather"
#       }
#     }
#     ingress {
#       from {
#         pod_selector {
#           match_labels = {
#             app = "haproxy"
#           }
#         }
#       }
#       ports {
#         protocol = "TCP"
#         port     = 8080
#       }
#       ports {
#         protocol = "TCP"
#         port     = 10250
#       }
#     }
#     policy_types = ["Ingress"]
#   }
# }

# resource "kubernetes_network_policy" "allow_web_postgres" {
#   metadata {
#     name      = "allow-web-postgres"
#     namespace = "default"
#   }
#   spec {
#     pod_selector {
#       match_labels = {
#         app = "postgres"
#       }
#     }
#     ingress {
#       from {
#         pod_selector {
#           match_labels = {
#             app = "web-server"
#           }
#         }
#       }
#       ports {
#         protocol = "TCP"
#         port     = 5432
#       }

#       ports {
#         protocol = "TCP"
#         port     = 10250
#       }
#     }
#     policy_types = ["Ingress"]
#   }
# }
