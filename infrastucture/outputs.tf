# Outputs
output "user_names" {
  description = "Names of created users"
  value       = [for user in aws_iam_user.users : user.name]
}

output "user_arns" {
  description = "ARNs of created users"
  value       = [for user in aws_iam_user.users : user.arn]
}

output "access_key_ids" {
  description = "Access key IDs for users"
  value       = [for key in aws_iam_access_key.users : key.id]
}

output "secret_access_keys" {
  description = "Secret access keys for users"
  value       = [for key in aws_iam_access_key.users : key.secret]
  sensitive   = true
}