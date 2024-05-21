resource "kubernetes_secret" "web_server_certs" {
  metadata {
    name = "web-server-certs"
  }
  data = {
    "server.crt" = file(var.local_cert_path)
    "server.key" = file(var.local_key_path)
  }
}
