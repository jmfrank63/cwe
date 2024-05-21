resource "null_resource" "manage_configmap" {
  provisioner "local-exec" {
    command = "kubectl create configmap web-server-env --from-env-file=${path.module}/../../../../server/.env --namespace default"
    when = create
  }

  provisioner "local-exec" {
    command = "kubectl delete configmap web-server-env --namespace default"
    when = destroy    
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "kubernetes_config_map" "web_server_env_file" {
  metadata {
    name = "web-server-env-file"
  }
  data = {
    ".env" = file("${path.module}/../../../../server/.env")
  }
}
