resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name = "pgdata-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
