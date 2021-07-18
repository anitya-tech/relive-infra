terraform {
  required_providers {
    mongodb = {
      source  = "Kaginari/mongodb"
      version = "~> 0.0.5"
    }
  }
}

locals {
  valut_prefix = "${var.valut_prefix}/${var.env_name}"
}
