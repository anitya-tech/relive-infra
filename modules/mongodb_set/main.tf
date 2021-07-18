terraform {
  required_providers {
    mongodb = {
      source  = "Kaginari/mongodb"
      version = "~> 0.0.5"
    }
  }
}

resource "mongodb_db_role" "default" {
  name     = var.role
  database = var.database

  inherited_role {
    role = "readWrite"
    db   = var.database
  }
}

resource "random_password" "default" {
  length  = 24
  special = false
}

resource "mongodb_db_user" "default" {
  depends_on = [mongodb_db_role.default]

  auth_database = mongodb_db_role.default.database
  name          = var.user
  password      = random_password.default.result
  role {
    role = mongodb_db_role.default.name
    db   = var.database
  }
}

resource "vault_generic_secret" "mongo" {
  path = "${var.valut_prefix}/rw"

  data_json = jsonencode({
    hostname      = var.host
    ssl           = false
    port          = 27017
    database      = var.database
    username      = mongodb_db_user.default.name
    password      = mongodb_db_user.default.password
    auth_database = mongodb_db_user.default.auth_database
  })
}
