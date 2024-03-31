# prowlarr

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                              | Default             |
|-----------------------------------|---------------------|
| PROWLARR__ANALYTICS_ENABLED       | `False`             |
| PROWLARR__API_KEY                 |                     |
| PROWLARR__AUTHENTICATION_METHOD   | `None`              |
| PROWLARR__AUTHENTICATION_REQUIRED |                     |
| PROWLARR__BRANCH                  | _(current channel)_ |
| PROWLARR__INSTANCE_NAME           | `Prowlarr`          |
| PROWLARR__LOG_LEVEL               | `info`              |
| PROWLARR__PORT                    | `9696`              |
| PROWLARR__POSTGRES_HOST           |                     |
| PROWLARR__POSTGRES_MAIN_DB        |                     |
| PROWLARR__POSTGRES_LOG_DB         |                     |
| PROWLARR__POSTGRES_PASSWORD       |                     |
| PROWLARR__POSTGRES_PORT           | `5432`              |
| PROWLARR__POSTGRES_USER           |                     |
| PROWLARR__URL_BASE                |                     |
