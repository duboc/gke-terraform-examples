terraform {
 backend "gcs" {
   bucket  = "duboc-tf-state"
   prefix  = "terraform/state"
   
 }
}