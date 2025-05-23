# variables.tf - Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
# Variables for user configuration
variable "users" {
  description = "Map of users to create"
  type = map(object({
    name = string
    path = string
  }))
  default = {
    "user1" = {
      name = "user2"
      path = "/"
    }
    "user2" = {
      name = "user3"
      path = "/"
    }
  }
}

variable "existing_group_name" {
  description = "Name of the pre-existing IAM group"
  type        = string
  default     = "course-user" # Change this to your existing group name
}
