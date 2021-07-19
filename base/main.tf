terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "anitya-tech"

    workspaces {
      name = "relive-base"
    }
  }
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "~> 1.2.0"
    }
    rabbitmq = {
      source  = "cyrilgdn/rabbitmq"
      version = "~> 1.5.1"
    }
    mongodb = {
      source  = "Kaginari/mongodb"
      version = "~> 0.0.5"
    }
  }
}

provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}

locals {
  vault_prefix = "projects/anitya/relive/base"
}
