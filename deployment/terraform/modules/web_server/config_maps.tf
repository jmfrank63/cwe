resource "kubernetes_config_map" "web_server_env" {
  metadata {
    name = "web-server-env"
  }
  data = {
    ".env" = file("/home/johannes/Projects/Rust/cwe/server/.env")
  }
}
