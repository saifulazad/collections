variable "gcp_region" {
  type    = string
  default = "us-central1"
}
variable "services_to_enable" {
  description = "The list of services to enable."
  type        = list(string)
  default = [
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "alloydb.googleapis.com",
    "texttospeech.googleapis.com"
  ]
}
