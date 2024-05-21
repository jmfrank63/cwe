resource "kubernetes_secret" "haproxy_certs" {
  metadata {
    name = "haproxy-certs"
  }
  data = {
    "admin.pem" = file("/home/johannes/.local/ssl/certs/cwe/admin.pem")
  }
}
