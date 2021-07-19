terraform {
  required_providers {
    mongodb = {
      source  = "Kaginari/mongodb"
      version = "~> 0.0.5"
    }
  }
}

locals {
  vault_prefix          = "${var.vault_prefix}/${var.env_name}"
  vault_approle_backend = "approle"
}
