
locals {
  project_id = "dubogarden"
  cluster_name = "meu-cluster01"
}


data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

# tflint-ignore: terraform_module_version
module "gke" {
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  project_id                        = "dubogarden"
  network_project_id                = "duboc-shared-vpc"
  name                              = local.cluster_name
  region                            = "us-central1"
  regional                        = true
  #zones                             = ["us-central1-b", "us-central1-c", "us-central1-a"]
  network                           = "shared-vpc"
  subnetwork                        = "gke-autopilot-network"
  ip_range_pods                     = "auto-pods"
  ip_range_services                 = "auto-services"
  create_service_account            = true
  release_channel                 = "REGULAR"
  enable_vertical_pod_autoscaling = true
  enable_private_endpoint         = true
  enable_private_nodes            = true
  master_ipv4_cidr_block          = "172.16.0.0/28"
  #remove_default_node_pool          = true
  #disable_legacy_metadata_endpoints = false

  master_authorized_networks = [
    {
      cidr_block   = "10.0.2.0/24"
      display_name = "Safe Network"
    },
  ]

}


resource "google_service_account" "workload_identity_sa" {
  project      = local.project_id
  account_id   = "workload-identity-iam-sa"
  display_name = "A service account to be used by GKE Workload Identity"
}


# Binding between IAM SA and Kubernetes SA
resource "google_service_account_iam_binding" "gke_iam_binding" {
  service_account_id = google_service_account.workload_identity_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    # "serviceAccount:<PROJECT_ID>.svc.id.goog[<KUBERNETES_NAMESPACE>/<HELM_PACKAGE_INSTALLED_NAME>-common-backend]"
    "serviceAccount:${local.project_id}.svc.id.goog[carto/carto-common-backend]",
  ]
}


# This role enables impersonation of service accounts to create OAuth2 access tokens, sign blobs, or sign JWTs
resource "google_service_account_iam_member" "workload_identity_sa_sign_urls" {
  service_account_id = google_service_account.workload_identity_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.workload_identity_sa.email}"
}


