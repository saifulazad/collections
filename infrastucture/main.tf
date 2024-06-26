terraform {
  backend "gcs" {
  }
  required_providers {
    google = {
      version = "~> 5.30.0"
    }
  }
}
provider "google" {
  project = ""
  region  = var.gcp_region
}

resource "google_project_service" "project" {
  for_each                   = toset(var.services_to_enable)
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = false
}

# terraform init -reconfigure -backend-config="backends/dev.gcs.tfbackend"
# terraform apply -var-file=tf_vars/dev.tfvars