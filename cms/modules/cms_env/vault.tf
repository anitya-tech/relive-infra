resource "vault_policy" "relive_cms" {
  name = "relive-cms-${var.env_name}"

  policy = <<EOT
path "${local.vault_prefix}/*" { capabilities = ["read"] }
EOT
}

resource "vault_approle_auth_backend_role" "relive_cms" {
  backend        = local.vault_approle_backend
  role_name      = "relive-cms-${var.env_name}"
  role_id        = "relive-cms-${var.env_name}"
  token_policies = ["default", vault_policy.relive_cms.name]
}

resource "vault_approle_auth_backend_role_secret_id" "relive_cms" {
  backend   = local.vault_approle_backend
  role_name = vault_approle_auth_backend_role.relive_cms.role_name
}
