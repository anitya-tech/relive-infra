data "vault_generic_secret" "mongo" { path = "geektr.co/databases/mongo/hinata" }
locals { value_mongo = data.vault_generic_secret.mongo.data }
locals { mongo = {
  database = "relive"
  role     = "relive"
  user     = "relive"
} }

provider "mongodb" {
  host          = local.value_mongo.host
  port          = "27017"
  username      = local.value_mongo.user
  password      = local.value_mongo.passwd
  auth_database = "admin"
  ssl           = false
}

resource "mongodb_db_role" "relive" {
  name     = local.mongo.role
  database = local.mongo.database
  privilege {
    db         = local.mongo.database
    collection = ""
    actions    = ["listCollections", "createCollection", "createIndex", "dropIndex", "insert", "remove", "renameCollectionSameDB", "update"]
  }
}

resource "random_password" "mongo_relive" {
  length  = 24
  special = false
}

resource "mongodb_db_user" "relive" {
  auth_database = mongodb_db_role.relive.database
  name          = local.mongo.user
  password      = random_password.mongo_relive.result
  role {
    role = mongodb_db_role.relive.name
    db   = local.mongo.database
  }
}

resource "vault_generic_secret" "mongo" {
  path = "${local.valut_prefix}/mongo/rw"

  data_json = jsonencode({
    hostname      = local.value_mongo.host,
    ssl           = false
    port          = "27017"
    auth_database = mongodb_db_user.relive.auth_database
    username      = mongodb_db_user.relive.name,
    password      = mongodb_db_user.relive.password,
  })
}
