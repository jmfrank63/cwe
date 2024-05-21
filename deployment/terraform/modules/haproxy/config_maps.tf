# resource "null_resource" "haproxy_config" {
#   provisioner "local-exec" {
#     command = "kubectl create configmap haproxy-config --from-file=/home/johannes/Projects/Rust/cwe/haproxy/haproxy.cfg --dry-run=client -o yaml | kubectl apply -f -"
#   }
# }

resource "kubernetes_config_map" "haproxy_config" {
  metadata {
    name = "haproxy-config"
  }
  data = {
    "haproxy.cfg" = file("/home/johannes/Projects/Rust/cwe/haproxy/haproxy.cfg")
  }
}
