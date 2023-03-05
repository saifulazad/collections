variable "google_credentials" {
  description = "the contents of a service account key file in JSON format."
  type        = string
  default     = "/home/muazzem/Downloads/gcp-key.json"
}

variable "project" {
  default = "saifuls-playground"
}
variable "stage" {
  default = "test"
}
variable "network" {
  default = "default"
}
variable "db_pass" {
  type    = string
  default = "Fr@ctalslab3110"
}