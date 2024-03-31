# sonarr

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                            | Default             |
|---------------------------------|---------------------|
| SONARR__ANALYTICS_ENABLED       | `False`             |
| SONARR__API_KEY                 |                     |
| SONARR__AUTHENTICATION_METHOD   | `None`              |
| SONARR__AUTHENTICATION_REQUIRED |                     |
| SONARR__BRANCH                  | _(current channel)_ |
| SONARR__INSTANCE_NAME           | `sonarr`            |
| SONARR__LOG_LEVEL               | `info`              |
| SONARR__PORT                    | `8989`              |
| SONARR__POSTGRES_HOST           |                     |
| SONARR__POSTGRES_MAIN_DB        |                     |
| SONARR__POSTGRES_LOG_DB         |                     |
| SONARR__POSTGRES_PASSWORD       |                     |
| SONARR__POSTGRES_PORT           | `5432`              |
| SONARR__POSTGRES_USER           |                     |
| SONARR__URL_BASE                |                     |
