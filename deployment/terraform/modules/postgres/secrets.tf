resource "kubernetes_secret" "postgres_ssl_certs" {
  metadata {
    name = "postgres-ssl-certs"
  }
  data = {
    "server.crt" = file("/home/johannes/.local/ssl/certs/cwe/cwe.crt")
    "server.key" = file("/home/johannes/.local/ssl/certs/cwe/cwe.key")
  }
}
