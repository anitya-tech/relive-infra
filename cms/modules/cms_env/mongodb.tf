provider "mongodb" {
  host          = var.mongo_cred.host
  port          = "27017"
  username      = var.mongo_cred.user
  password      = var.mongo_cred.passwd
  auth_database = "admin"
  ssl           = false
}

module "mongodb" {
  source = "./modules/mongodb_set"

  valut_prefix = "${local.valut_prefix}/mongo"

  host     = var.mongo_cred.host
  database = "relive-cms-${var.env_name}"
  role     = "relive-cms-${var.env_name}"
  user     = "relive-cms-${var.env_name}"
}
