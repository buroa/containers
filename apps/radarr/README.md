# radarr

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                            | Default             |
|---------------------------------|---------------------|
| RADARR__ANALYTICS_ENABLED       | `False`             |
| RADARR__API_KEY                 |                     |
| RADARR__AUTHENTICATION_METHOD   | `None`              |
| RADARR__AUTHENTICATION_REQUIRED |                     |
| RADARR__BRANCH                  | _(current channel)_ |
| RADARR__INSTANCE_NAME           | `Radarr`            |
| RADARR__LOG_LEVEL               | `info`              |
| RADARR__PORT                    | `7878`              |
| RADARR__POSTGRES_HOST           |                     |
| RADARR__POSTGRES_MAIN_DB        |                     |
| RADARR__POSTGRES_LOG_DB         |                     |
| RADARR__POSTGRES_PASSWORD       |                     |
| RADARR__POSTGRES_PORT           | `5432`              |
| RADARR__POSTGRES_USER           |                     |
| RADARR__URL_BASE                |                     |
