variable "gcp_service_list" {
  description ="The list of apis necessary for the project"
  type = list(string)
  default = [
    "redis.googleapis.com", 
    "compute.googleapis.com", 
    "sqladmin.googleapis.com", 
    "secretmanager.googleapis.com", 
    "servicenetworking.googleapis.com", 
    "cloudbuild.googleapis.com", 
    "cloudresourcemanager.googleapis.com"
    ]
}

resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project = "dubogarden"
  service = each.key
}