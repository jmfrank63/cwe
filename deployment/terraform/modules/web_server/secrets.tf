resource "kubernetes_secret" "web_server_certs" {
  metadata {
    name = "web-server-certs"
  }
  data = {
    "server.crt" = file("/home/johannes/.local/ssl/certs/cwe/cwe.crt")
    "server.key" = file("/home/johannes/.local/ssl/certs/cwe/cwe.key")
  }
}
