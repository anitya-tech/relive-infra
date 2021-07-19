data "vault_generic_secret" "redis" { path = "geektr.co/databases/redis/hinata" }
locals { value_redis = data.vault_generic_secret.redis.data }

resource "vault_generic_secret" "redis" {
  path = "${local.vault_prefix}/redis/rw"

  data_json = jsonencode({
    hostname = local.value_redis.host,
    port     = 6379,
    prefix   = "relive."
    password = local.value_redis.passwd
  })
}
