variable "rolesList" {
  type    = list(string)
  default = ["roles/artifactregistry.admin", "roles/run.admin", "roles/iam.serviceAccountUser"]
}
variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "us-central1-c"
}
variable "project_id" {
  default = "saifuls-playground"
}
variable "service_account_id" {
  default = "github-action-sa"
}
variable "pool_id" {
  default = "github-action-pool"
}
variable "provider_id" {}
variable "git_repo" {
  default = "attribute.repository/Muazzeem/flask_application"
}

