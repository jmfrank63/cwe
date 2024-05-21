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
