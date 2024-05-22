variable "geonames_username" {
  description = "GeoNames username for the weather service"
  type        = string
}

variable "postgres_user" {
  description = "Postgres username for the weather service"
  type        = string
}

variable "postgres_password" {
  description = "Postgres password for the weather service"
  type        = string
}

variable "postgres_db" {
  description = "Postgres database for the weather service"
  type        = string
}
