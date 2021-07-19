data "vault_generic_secret" "rabbitmq" { path = "geektr.co/databases/rabbitmq/hinata" }
locals { value_rabbitmq = data.vault_generic_secret.rabbitmq.data }

provider "rabbitmq" {
  endpoint = "http://${local.value_rabbitmq.host}:5673"
  username = "root"
  password = local.value_rabbitmq.passwd
}

resource "rabbitmq_vhost" "relive" { name = "relive" }

resource "random_password" "rabbitmq_relive" {
  length  = 24
  special = false
}

resource "rabbitmq_user" "relive" {
  name     = "relive"
  password = random_password.rabbitmq_relive.result
}

resource "rabbitmq_permissions" "relive" {
  user  = rabbitmq_user.relive.name
  vhost = rabbitmq_vhost.relive.name

  permissions {
    configure = ".*"
    write     = ".*"
    read      = ".*"
  }
}

resource "vault_generic_secret" "rabbitmq" {
  path = "${local.vault_prefix}/rabbitmq/rw"

  data_json = jsonencode({
    hostname : local.value_rabbitmq.host,
    username : rabbitmq_user.relive.name,
    password : rabbitmq_user.relive.password,
    vhost : rabbitmq_vhost.relive.name,
  })
}

# module "rabbitmq_relive" {
#   source = "./modules/ez_rabbitmq"

#   vhost = "relive"

#   exchanges = [
#     "origin.stream.recorded",
#     "origin.video.uploaded",
#     "origin.danmaku.uploaded",
#   ]

#   queues = [
#     "origin.stream.upload",
#     "origin.video.convert",
#     "origin.danmaku.convert",
#   ]

#   bindings = [
#     "origin.stream.recorded -> origin.stream.upload",
#     "origin.video.uploaded -> origin.video.convert",
#     "origin.danmaku.uploaded -> origin.danmaku.convert",
#   ]
# }
