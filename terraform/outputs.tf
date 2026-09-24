output "edge_app_id" {
  description = "Zedcloud id of the updated edge-app."
  value       = zedcloud_application.compose.id
}

output "edge_app_name" {
  description = "Edge-app name that was updated."
  value       = zedcloud_application.compose.name
}

output "project_name" {
  description = "Project whose matching edge-app instances are purged."
  value       = var.project_name
}
