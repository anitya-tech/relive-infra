# Relive Infra Base

## [Minio Storage](https://anita.minio.geektr.co:9002/minio/relive-bili/)

| Key      | Value                             |
| -------- | --------------------------------- |
| Bucket   | `relive-bili`                     |
| RW Group | `relive_rw`                       |
| RO Group | `relive_ro`                       |
| RW Cred  | `geektr.co/minio/anita/relive_rw` |
| RO Cred  | `geektr.co/minio/anita/relive_ro` |

**Bugs**: minio provider can't update policy

https://github.com/aminueza/terraform-provider-minio/issues/64
https://github.com/aminueza/terraform-provider-minio/issues/105

dirty fix:

```bash
cat >/tmp/minio-policy<<EOF

EOF
mc admin policy add anita_root <policy> /tmp/minio-policy
```

## MongoDB

DB: `relive`
Cred: `anitya/relive/base/mongo/rw`

## RabbitMQ

VHost: `relive`
Cred: `anitya/relive/base/rabbitmq/rw`

## Redis

Prefix: `relive.`
