variable "local_cert_path" {
  description = "Path to the local certificate file"
  type        = string
  default     = "/home/johannes/.local/ssl/certs/cwe/cwe.crt"
}

variable "local_key_path" {
  description = "Path to the local key file"
  type        = string
  default     = "/home/johannes/.local/ssl/certs/cwe/cwe.key"
}

variable "local_pem_path" {
  description = "Path to the local pem file"
  type        = string
  default     = "/home/johannes/.local/ssl/certs/cwe/admin.pem"
}

variable "geonames_username" {
  description = "GeoNames username for the weather service"
  type        = string
  default = "jmfrank63"
}

variable "postgres_user" {
  description = "Postgres username for the weather service"
  type        = string
  default = "postgres"
}

variable "postgres_password" {
  description = "Postgres password for the weather service"
  type        = string
  default = "postgres"
}

variable "postgres_db" {
  description = "Postgres database for the weather service"
  type        = string
  default = "postgres"
}
