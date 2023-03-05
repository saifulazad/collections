#
#Deploy a private database connector on Google Cloud Platform using Terraform.
#
#Args:
#- project (str): The GCP project ID to deploy the connector in.
#- db_pass (str): The root password for the database instance.
#
#Returns:
#- None
# Configure Terraform backend to store state file in GCS

terraform {
  backend "gcs" {
    bucket = "saifuls-playground"
    prefix = "sate-files/private-db-connector"
  }
}

# Configure GCP provider to use
provider "google" {
  project = "saifuls-playground"
  region  = "us-central1"
  zone    = "us-central1-c"
}

# Deploy VPC access connector
resource "google_vpc_access_connector" "default" {
  name          = "serverless-vpc-connector"
  network       = "projects/${var.project}/global/networks/default"
  ip_cidr_range = "10.8.0.0/28"
}
# Generate random ID for database instance name suffix
resource "random_id" "db_name_suffix" {
  byte_length = 4
}
# Deploy private database instance
resource "google_sql_database_instance" "instance" {
  provider = google-beta
  project  = var.project

  name             = "private-instance-${random_id.db_name_suffix.hex}"
  region           = "us-central1"
  database_version = "POSTGRES_14"
  root_password    = var.db_pass

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = "projects/${var.project}/global/networks/default"
      enable_private_path_for_google_cloud_services = true
    }
  }
}
