variable "zedcloud_url" {
  description = "Zedcloud API URL. Example: https://zedcontrol.zededa.net"
  type        = string
}

variable "zedcloud_token" {
  description = "Zedcloud API token."
  type        = string
  sensitive   = true
}

variable "edge_app_name" {
  description = "Existing Zededa edge-app name whose Docker Compose manifest is updated."
  type        = string
}

variable "edge_app_title" {
  description = "Edge-app title. Leave empty to use edge_app_name."
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Zededa project whose edge-app instances of this edge-app are purged after the manifest update."
  type        = string
}

variable "manifest_ac_kind" {
  description = "Edge-app manifest acKind."
  type        = string
  default     = "ComposeManifest"
}

variable "manifest_ac_version" {
  description = "Edge-app manifest acVersion."
  type        = string
  default     = "1.2.0"
}

variable "app_type" {
  description = "Edge-app bundle type."
  type        = string
  default     = "APP_TYPE_DOCKER_COMPOSE"
}

variable "deployment_type" {
  description = "Edge-app deployment type."
  type        = string
  default     = "DEPLOYMENT_TYPE_STAND_ALONE"
}
