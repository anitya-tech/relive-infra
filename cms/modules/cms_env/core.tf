resource "random_password" "admin_jwt_secret" {
  length  = 32
  special = false
}

resource "random_uuid" "jwt_secret" {}


resource "vault_generic_secret" "core" {
  path = "${local.vault_prefix}/core"

  data_json = jsonencode({
    admin_jwt_secret = random_password.admin_jwt_secret.result
    jwt_secret       = random_uuid.jwt_secret.result
  })
}
