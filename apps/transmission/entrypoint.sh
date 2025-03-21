#!/usr/bin/env bash

minijinja-cli --env /settings.json.j2 > /config/settings.json

if [[ "${TRANSMISSION__DEBUG}" == "true" ]]; then
    echo "Transmission starting with the following configuration..."
    cat /config/settings.json
fi

#shellcheck disable=SC2086
exec \
    /usr/bin/transmission-daemon \
        --foreground \
        --config-dir /config \
        --log-level "${TRANMISSIONS__LOG_LEVEL:-info}" \
        --port "${TRANSMISSION__RPC_PORT:-9091}" \
        "$@"
