terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
  }
}

# provider.tf - AWS Provider Configuration
provider "aws" {
  region = var.aws_region
}



# Get current AWS account ID and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = var.aws_region
}

# Create IAM users using for_each loop
resource "aws_iam_user" "users" {
  for_each = var.users

  name = each.value.name
  path = each.value.path

  tags = {
    Name        = each.value.name
    Environment = "production"
    CreatedBy   = "terraform"
  }
}

# Create login profiles for users (optional - for console access)
resource "aws_iam_user_login_profile" "users" {
  for_each = var.users

  user                    = aws_iam_user.users[each.key].name
  password_reset_required = true

  depends_on = [aws_iam_user.users]
}

# Add users to existing group
resource "aws_iam_group_membership" "users_group_membership" {
  name = "users-group-membership"

  users = [
    for user in aws_iam_user.users : user.name
  ]

  group = var.existing_group_name
}

# Create IAM policy for users
resource "aws_iam_policy" "user_policy" {
  name        = "UserCustomPolicy"
  path        = "/"
  description = "Custom policy for created users"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListAllBuckets"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::jobkhuzi-learners/*",
          "arn:aws:s3:::jobkhuzi-learners"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeImages"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach custom policy to GROUP (not individual users)
resource "aws_iam_group_policy_attachment" "custom_policy_attachment" {
  group      = var.existing_group_name
  policy_arn = aws_iam_policy.user_policy.arn
}




resource "aws_iam_policy" "ecr_specific_repo" {
  name        = "ECRSpecificRepository"
  description = "Access to specific ECR repository only"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "GetAuthorizationToken"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Sid    = "AccessSpecificRepository"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:ListImages"
        ]
        Resource = "arn:aws:ecr:${local.region}:${local.account_id}:repository/demo-docker-image"
      }
    ]
  })
}

# Attach comprehensive policy to ECR users group
resource "aws_iam_group_policy_attachment" "ecr_users_policy" {
  group      = var.existing_group_name
  policy_arn = aws_iam_policy.ecr_specific_repo.arn
}




# Create access keys for users (optional - for programmatic access)
resource "aws_iam_access_key" "users" {
  for_each = var.users

  user = aws_iam_user.users[each.key].name
}

