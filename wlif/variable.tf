variable "project_id" {
  default = "saifuls-playground"
}
variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "us-central1-c"
}
variable "service_account_id" {
  description = "The name of service account. Make sure that is unique across the project. Below there are list of roles for that service account."
  type = string
  default = "github-action-sa"
}
variable "rolesList" {
  description = "List of roles that will be associated to the service account `service_account_id`."
  type    = list(string)
  default = ["roles/secretmanager.secretAccessor"]
}
variable "pool_id" {
  default = "sample-github-action-pool"
}
variable "provider_id" {
  default = "sample-gha-wlif-work"
}
variable "git_repo" {
  description = "The name of the repository to use workload identitiy fed. Value is attribute.repository/username/reponame"
  default = "attribute.repository/saifulazad/gcp-infra"
}
