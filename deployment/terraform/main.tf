provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "postgres" {
  source = "./modules/postgres"
  local_cert_path = var.local_cert_path
  local_key_path = var.local_key_path
}

module "web_server" {
  source = "./modules/web_server"
  local_cert_path = var.local_cert_path
  local_key_path = var.local_key_path
  depends_on = [ module.postgres ]
}

module "haproxy" {
  source = "./modules/haproxy"
  local_pem_path = var.local_pem_path
  depends_on = [ module.web_server ]
}
