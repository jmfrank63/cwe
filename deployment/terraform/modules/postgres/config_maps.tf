resource "null_resource" "manage_configmap" {
  provisioner "local-exec" {
    command = "kubectl create configmap postgres-env --from-env-file=${path.module}/../../../../db/.env --namespace default"
    when = create
  }

  provisioner "local-exec" {
    command = "kubectl delete configmap postgres-env --namespace default"
    when = destroy    
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "kubernetes_config_map" "postgres_config" {
  metadata {
    name = "postgres-config"
  }
  data = {
    "postgresql.conf" = file("${path.module}/../../../../db/postgres/postgresql.conf")
  }
}
