variable "rolesList" {
  type    = list(string)
  default = ["roles/artifactregistry.admin", "roles/run.admin", "roles/iam.serviceAccountUser"]
}

variable "project_id" {
  default = "saifuls-playground"
}
variable "git_repo" {
  default = "attribute.repository/Muazzeem/flask_application"
}

