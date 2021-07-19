data "vault_generic_secret" "minio" { path = "geektr.co/minio/anita/root" }
locals { value_minio = data.vault_generic_secret.minio.data }

provider "minio" {
  minio_server     = local.value_minio.MINIO_SERVER
  minio_region     = local.value_minio.MINIO_REGION
  minio_access_key = local.value_minio.MINIO_ACCESS_KEY
  minio_secret_key = local.value_minio.MINIO_SECRET_KEY
  minio_ssl        = true
}

resource "minio_s3_bucket" "origin" {
  bucket = "relive-bili"
  acl    = "private"
  lifecycle { prevent_destroy = true }
}

resource "minio_iam_policy" "relive_rw" {
  name   = "relive-rw"
  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:*"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::relive-bili/*"],
      "Sid": "Terraform"
    }
  ]
}
EOT
}

resource "minio_iam_policy" "relive_ro" {
  name   = "relive-ro"
  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:GetObject","s3:ListBucket"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::relive-bili/*"],
      "Sid": "Terraform"
    }
  ]
}
EOT
}

resource "minio_iam_group" "relive_rw" { name = "relive-rw" }
resource "minio_iam_group" "relive_ro" { name = "relive-ro" }

resource "minio_iam_group_policy_attachment" "relive_rw" {
  group_name  = minio_iam_group.relive_rw.name
  policy_name = minio_iam_policy.relive_rw.id
}
resource "minio_iam_group_policy_attachment" "relive_ro" {
  group_name  = minio_iam_group.relive_ro.name
  policy_name = minio_iam_policy.relive_ro.id
}

resource "minio_iam_user" "relive_rw" { name = "relive_rw" }
resource "minio_iam_user" "relive_ro" { name = "relive_ro" }

resource "minio_iam_group_user_attachment" "relive_rw" {
  group_name = minio_iam_group.relive_rw.name
  user_name  = minio_iam_user.relive_rw.name
}
resource "minio_iam_group_user_attachment" "relive_ro" {
  group_name = minio_iam_group.relive_ro.name
  user_name  = minio_iam_user.relive_ro.name
}

resource "vault_generic_secret" "minio_rw" {
  path = "${local.vault_prefix}/minio/rw"

  data_json = jsonencode({
    minio_server     = local.value_minio.MINIO_SERVER
    minio_region     = local.value_minio.MINIO_REGION
    minio_access_key = "relive_rw"
    minio_secret_key = minio_iam_user.relive_rw.secret
  })
}

resource "vault_generic_secret" "minio_ro" {
  path = "${local.vault_prefix}/minio/ro"

  data_json = jsonencode({
    minio_server     = local.value_minio.MINIO_SERVER
    minio_region     = local.value_minio.MINIO_REGION
    minio_access_key = "relive_ro"
    minio_secret_key = minio_iam_user.relive_ro.secret
  })
}
