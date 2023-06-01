variable "redis_name" { 
    type = string
}

variable "region"{
    type = string
    default = "us-central1"
 }

variable "zone" {
    type = string
    default = "us-central1-a"
  
}
variable "redis_memory_size_gb" {
  type        = number
  description = "Redis memory size"
  default     = 1
}

variable "redis_tier" {
  type        = string
  description = "Redis tier. If we are going to really use in production, we must use `var.production_mode`"
  default     = "STANDARD_HA"
}

variable "redis_version" {
  type        = string
  description = "Redis version to use.\nhttps://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance#redis_version"
  default     = "REDIS_6_X"
}
