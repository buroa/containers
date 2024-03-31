#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

# Discover existing configuration settings for backwards compatibility
if [[ -f /config/config.xml ]]; then
    current_log_level="$(xmlstarlet sel -t -v "//LogLevel" -nl /config/config.xml)"
    current_url_base="$(xmlstarlet sel -t -v "//UrlBase" -nl /config/config.xml)"
    current_branch="$(xmlstarlet sel -t -v "//Branch" -nl /config/config.xml)"
    current_analytics_enabled="$(xmlstarlet sel -t -v "//AnalyticsEnabled" -nl /config/config.xml)"
    current_api_key="$(xmlstarlet sel -t -v "//ApiKey" -nl /config/config.xml)"
    current_authentication_method="$(xmlstarlet sel -t -v "//AuthenticationMethod" -nl /config/config.xml)"
    current_authentication_required="$(xmlstarlet sel -t -v "//AuthenticationRequired" -nl /config/config.xml)"
    current_instance_name="$(xmlstarlet sel -t -v "//InstanceName" -nl /config/config.xml)"
    current_postgres_user="$(xmlstarlet sel -t -v "//PostgresUser" -nl /config/config.xml)"
    current_postgres_password="$(xmlstarlet sel -t -v "//PostgresPassword" -nl /config/config.xml)"
    current_postgres_port="$(xmlstarlet sel -t -v "//PostgresPort" -nl /config/config.xml)"
    current_postgres_host="$(xmlstarlet sel -t -v "//PostgresHost" -nl /config/config.xml)"
    current_postgres_main_db="$(xmlstarlet sel -t -v "//PostgresMainDb" -nl /config/config.xml)"
    current_postgres_log_db="$(xmlstarlet sel -t -v "//PostgresLogDb" -nl /config/config.xml)"
    current_theme="$(xmlstarlet sel -t -v "//Theme" -nl /config/config.xml)"
fi

# Update config.xml with environment variables
envsubst < /app/config.xml.tmpl > /config/config.xml

# Override configuation values from existing config.xml if there are no SONARR__ variables set
[[ -z "${SONARR__LOG_LEVEL}" && -n "${current_log_level}" ]] && xmlstarlet edit --inplace --update //LogLevel -v "${current_log_level}" /config/config.xml
[[ -z "${SONARR__URL_BASE}" && -n "${current_url_base}" ]] && xmlstarlet edit --inplace --update //UrlBase -v "${current_url_base}" /config/config.xml
[[ -z "${SONARR__BRANCH}" && -n "${current_branch}" ]] && xmlstarlet edit --inplace --update //Branch -v "${current_branch}" /config/config.xml
[[ -z "${SONARR__ANALYTICS_ENABLED}" && -n "${current_analytics_enabled}" ]] && xmlstarlet edit --inplace --update //AnalyticsEnabled -v "${current_analytics_enabled}" /config/config.xml
[[ -z "${SONARR__API_KEY}" && -n "${current_api_key}" ]] && xmlstarlet edit --inplace --update //ApiKey -v "${current_api_key}" /config/config.xml
[[ -z "${SONARR__AUTHENTICATION_METHOD}" && -n "${current_authentication_method}" ]] && xmlstarlet edit --inplace --update //AuthenticationMethod -v "${current_authentication_method}" /config/config.xml
[[ -z "${SONARR__AUTHENTICATION_REQUIRED}" && -n "${current_authentication_required}" ]] && xmlstarlet edit --inplace --update //AuthenticationRequired -v "${current_authentication_required}" /config/config.xml
[[ -z "${SONARR__INSTANCE_NAME}" && -n "${current_instance_name}" ]] && xmlstarlet edit --inplace --update //InstanceName -v "${current_instance_name}" /config/config.xml
[[ -z "${SONARR__POSTGRES_USER}" && -n "${current_postgres_user}" ]] && xmlstarlet edit --inplace --update //PostgresUser -v "${current_postgres_user}" /config/config.xml
[[ -z "${SONARR__POSTGRES_PASSWORD}" && -n "${current_postgres_password}" ]] && xmlstarlet edit --inplace --update //PostgresPassword -v "${current_postgres_password}" /config/config.xml
[[ -z "${SONARR__POSTGRES_PORT}" && -n "${current_postgres_port}" ]] && xmlstarlet edit --inplace --update //PostgresPort -v "${current_postgres_port}" /config/config.xml
[[ -z "${SONARR__POSTGRES_HOST}" && -n "${current_postgres_host}" ]] && xmlstarlet edit --inplace --update //PostgresHost -v "${current_postgres_host}" /config/config.xml
[[ -z "${SONARR__POSTGRES_MAIN_DB}" &&  -n "${current_postgres_main_db}" ]] && xmlstarlet edit --inplace --update //PostgresMainDb -v "${current_postgres_main_db}" /config/config.xml
[[ -z "${SONARR__POSTGRES_LOG_DB}" && -n "${current_postgres_log_db}" ]] && xmlstarlet edit --inplace --update //PostgresLogDb -v "${current_postgres_log_db}" /config/config.xml
[[ -z "${SONARR__THEME}" && -n "${current_theme}" ]] && xmlstarlet edit --inplace --update //Theme -v "${current_theme}" /config/config.xml

# BindAddress, LaunchBrowser, Port, EnableSsl, SslPort, SslCertPath, SslCertPassword, UpdateMechanism
# have been omited because their configuration is not really needed in a container environment

if [[ "${SONARR__LOG_LEVEL}" == "debug" || "${current_log_level}" == "debug" ]]; then
    echo "Starting with the following configuration..."
    xmlstarlet format --omit-decl /config/config.xml
fi

#shellcheck disable=SC2086
exec \
    /app/bin/Sonarr \
        --nobrowser \
        --data=/config \
        "$@"
