terraform {
  required_version = ">= 1.5.0"

  required_providers {
    zedcloud = {
      source  = "zededa/zedcloud"
      version = "~> 2.8"
    }
  }
}
