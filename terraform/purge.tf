resource "terraform_data" "purge_instances" {
  depends_on = [zedcloud_application.compose]

  triggers_replace = {
    compose_sha = filebase64sha256(local.compose_file)
    edge_app    = var.edge_app_name
    project     = var.project_name
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/../scripts/purge_edge_app_instances.sh"

    environment = {
      ZEDCLOUD_URL   = var.zedcloud_url
      ZEDCLOUD_TOKEN = var.zedcloud_token
      EDGE_APP_NAME  = var.edge_app_name
      PROJECT_NAME   = var.project_name
    }
  }
}
