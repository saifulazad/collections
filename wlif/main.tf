# Creates a Google Service Account with the specified ID in the specified project,
# grants the specified roles to the service account in the project, and outputs the
# email address of the service account.

terraform {
  backend "gcs" {
    # Save state files on google storage bucket
    bucket = "saifuls-playground"
    prefix = "sate-files/github-actions-runners"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_service_account" "service_account" {
#  project    = var.project_id
  account_id = var.service_account_id
}

resource "google_project_iam_member" "project" {
  /**
   * Creates a Google Cloud IAM member for a project.
   *
   * @param {string} project_id - The ID of the project.
   * @param {string[]} rolesList - The list of IAM roles to grant to the member.
   * @param {string} service_account_email - The email of the service account to grant the roles to.
   * @returns {object[]} An array of IAM member objects.
   */
  project = var.project_id
  count   = length(var.rolesList)
  role    = var.rolesList[count.index]
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

module "oidc" {

  /**
   * Creates a random ID and uses it to configure the gh-oidc module from the
   * terraform-google-modules/github-actions-runners/google module registry.
   *
   * @param {string} project_id - The ID of the Google Cloud project.
   * @return {string} The name of the GitHub Action provider.
   */

  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = var.project_id
  pool_id     = var.pool_id
  provider_id = var.provider_id
  sa_mapping  = {
    (google_service_account.service_account.account_id) = {
      sa_name   = google_service_account.service_account.name
      # @param {string} git_repo - The name of the GitHub repository.
      attribute = var.git_repo
    }
  }
}

output "provider_name" {
  /**
   * Returns the provider name of the OIDC module.
   *
   * @returns {string} The provider name.
 */
  value = module.oidc.provider_name
}
output "email" {
  value = google_service_account.service_account.email
}




