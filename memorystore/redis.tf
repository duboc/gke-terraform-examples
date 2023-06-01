locals {
  # Instance name
  redis_instance_name = "${var.redis_name}-${random_integer.random_redis.id}"
  project_id = "dubogarden"
}

# Name suffix
resource "random_integer" "random_redis" {
  min = 1000
  max = 9999
}

# Redis instance
resource "google_redis_instance" "default" {
  name               = local.redis_instance_name
  project            = local.project_id
  region             = var.region
  location_id        = var.zone
  memory_size_gb     = var.redis_memory_size_gb
  auth_enabled       = true
  tier               = var.redis_tier
  redis_version      = var.redis_version
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  authorized_network      = "projects/duboc-shared-vpc/global/networks/shared-vpc"
  read_replicas_mode      = "READ_REPLICAS_DISABLED"
  transit_encryption_mode = "DISABLED"

  maintenance_policy {
    weekly_maintenance_window {
      day = "MONDAY"
      start_time {
        hours = 5
      }
    }
  }
}

# Credentials stored in Google Secret Manager

resource "google_secret_manager_secret" "redis_password" {
  secret_id = "redis-auth-string-${google_redis_instance.default.name}"
  project   = local.project_id
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "redis_password" {
  secret      = google_secret_manager_secret.redis_password.id
  secret_data = google_redis_instance.default.auth_string
}