
variable "region" {
  type        = string
  description = "GCP region"
  default = "us-central1"
}

variable "zone" {
  description = "Gcloud project zone"
  type        = string
  default = "us-central1-a"
}

variable "production_mode" {
  description = "If production_mode is enabled we enable backup, PITR and HA"
  type        = bool
  default = true
}

variable "postgresl_name" {
  type        = string
  description = "Name of the postgresql instance"
}

variable "postgresql_version" {
  type        = string
  description = "Version of postgres to use.\nhttps://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version"
  default     = "POSTGRES_13"
}

variable "postgresql_deletion_protection" {
  type        = bool
  description = "Enable the deletion_protection for the database please. By default, it's the same as `production_mode` variable"
  default     = false
}

variable "postgresql_disk_autoresize" {
  type        = bool
  description = "Enable postgres autoresize"
  default     = true
}

variable "postgresql_disk_size_gb" {
  type        = number
  description = "Default postgres disk_size. Keep in mind that the value could be auto-increased using `postgresql_disk_autoresize` variable"
  default     = 20

}

variable "postgresql_tier" {
  description = "Postgres machine type to use"
  type        = string
  default = "db-custom-2-7680"
}

## Backups

variable "enable_create_internal_sql_backups" {
  description = "Indicate if create internal db backups managed by cloud-sql"
  type        = bool
  default = true
}