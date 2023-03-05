output "database_name" {
  value     = google_sql_database_instance.instance.name
}
output "private_ip" {
  value = google_sql_database_instance.instance.private_ip_address
}


