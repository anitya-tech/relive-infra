terraform {
  backend "remote" {
    organization = "anitya-tech"

    workspaces {
      name = "relive-cms"
    }
  }
}

// Vault
provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}

locals {
  valut_prefix = "projects/anitya/relive/cms"
}

// MongoDB
data "vault_generic_secret" "mongo" { path = "geektr.co/databases/mongo/hinata" }

module "dev" {
  source = "./modules/cms_env"

  valut_prefix = local.valut_prefix
  env_name     = "dev"

  mongo_cred = data.vault_generic_secret.mongo.data
}

module "prod" {
  source = "./modules/cms_env"

  valut_prefix = local.valut_prefix
  env_name     = "prod"

  mongo_cred = data.vault_generic_secret.mongo.data
}
