resource "kubernetes_config_map" "weather_env" {
  metadata {
    name = "weather-env"
  }
  data = {
    GEONAMES_USERNAME = var.geonames_username
    POSTGRES_USER     = var.postgres_user
    POSTGRES_PASSWORD = var.postgres_password
    POSTGRES_DB       = var.postgres_db
  }
}
