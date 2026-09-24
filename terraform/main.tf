locals {
  edge_app_title = var.edge_app_title != "" ? var.edge_app_title : var.edge_app_name
  compose_file   = "${path.module}/../docker-compose.yaml"
}

provider "zedcloud" {
  zedcloud_url   = var.zedcloud_url
  zedcloud_token = var.zedcloud_token
}

resource "zedcloud_application" "compose" {
  name                 = var.edge_app_name
  title                = local.edge_app_title
  description          = "Docker Compose edge-app updated from docker-compose.yaml."
  user_defined_version = substr(filebase64sha256(local.compose_file), 0, 12)

  manifest {
    ac_kind                  = var.manifest_ac_kind
    ac_version               = var.manifest_ac_version
    name                     = var.edge_app_name
    display_name             = local.edge_app_title
    app_type                 = var.app_type
    deployment_type          = var.deployment_type
    docker_compose_yaml_text = filebase64(local.compose_file)

    desc {
      app_category = "APP_CATEGORY_UNSPECIFIED"
    }
  }
}
