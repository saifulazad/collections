# AWS Vars
variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}
variable "aws_vpc" {
    default = "vpc-00e2e52531d0a9c46"
}

variable "aws_subnets" {
    type = list(string)
    default = ["subnet-0325b1e97eb32458d", "subnet-0a3f16b5e16e8fa18", 
            "subnet-09bbd47baf7b2102d", "subnet-08b3f1b8a8837f1e4"]
}
variable "aws_route_tables" {
  type = list(string)  
  default = ["rtb-02c75a3d70251f1f2", "rtb-08684a6b1a2dca140", "rtb-0b8f3adadd805f321",
  "rtb-050961ace32fe9d36", "rtb-0e67d9345c8fbfb84"]
}
variable "aws_region" {
    default = "us-west-2"
}

# GCP Vars
variable "gcp_project" {
  type = string
  default = "prod-shared-networking-fncpad7"
}
# variable "credentials_path" {
#   type = string
#   default = "D:\\credentials\\google\\dev-lsx-terraform.json"
# }
variable "gcp_vpc" {
    default = "usc1-prod-vpc"
}


variable "gcp_region" {
    default = "us-central1"
}

variable "gcp_bgp" {
    default = 65420
}