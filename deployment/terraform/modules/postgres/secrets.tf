resource "kubernetes_secret" "postgres_ssl_certs" {
  metadata {
    name = "postgres-ssl-certs"
  }
  data = {
    "server.crt" = file(var.local_cert_path)
    "server.key" = file(var.local_key_path)
  }
}
