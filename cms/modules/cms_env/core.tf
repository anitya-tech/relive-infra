resource "random_password" "admin_jwt_secret" {
  length  = 32
  special = false
}

resource "vault_generic_secret" "core" {
  path = "${local.valut_prefix}/core"

  data_json = jsonencode({
    admin_jwt_secret = random_password.admin_jwt_secret.result
  })
}
