provider "kubernetes" {
  config_path = "~/.kube/config"
}

# resource "null_resource" "haproxy_config" {
#   provisioner "local-exec" {
#     command = "kubectl create configmap haproxy-config --from-file=/home/johannes/Projects/Rust/cwe/haproxy/haproxy.cfg --dry-run=client -o yaml | kubectl apply -f -"
#   }
# }

module "postgres" {
  source = "./modules/postgres"
}

# module "web_server" {
#   source = "./modules/web_server"
# }

# module "haproxy" {
#   source = "./modules/haproxy"
#   depends_on = [null_resource.haproxy_config]
# }
