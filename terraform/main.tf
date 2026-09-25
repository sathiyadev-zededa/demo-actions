locals {
  edge_app_title = var.edge_app_title != "" ? var.edge_app_title : var.edge_app_name
  compose_file   = "${path.module}/../docker-compose.yaml"
}

provider "zedcloud" {
  zedcloud_url   = var.zedcloud_url
  zedcloud_token = var.zedcloud_token
}

resource "zedcloud_application" "compose" {
  name  = var.edge_app_name
  title = local.edge_app_title

  manifest {
    ac_kind                  = var.manifest_ac_kind
    ac_version               = var.manifest_ac_version
    name                     = var.edge_app_name
    display_name             = local.edge_app_title
    app_type                 = var.app_type
    deployment_type          = var.deployment_type
    docker_compose_yaml_text = filebase64(local.compose_file)

    desc {
      app_category = "APP_CATEGORY_EDGE_APPLICATION"
      category     = "APP_CATEGORY_EDGE_APPLICATION"
    }
  }

  lifecycle {
    ignore_changes = [
      datastore_id_list,
      description,
      user_defined_version,
      manifest[0].configuration,
      manifest[0].desc,
      manifest[0].module,
      manifest[0].owner,
    ]
  }
}
