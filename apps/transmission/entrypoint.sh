#!/usr/bin/env bash

# Update settings.json with environment variables
minijinja-cli --env --trim-blocks --lstrip-blocks /settings.json.j2 > /config/settings.json

if [[ "${TRANSMISSION__DEBUG}" == "true" ]]; then
    echo "Transmission starting with the following configuration..."
    cat /config/settings.json
fi

#shellcheck disable=SC2086
exec \
    /usr/bin/transmission-daemon \
        --foreground \
        --config-dir /config \
        --port "${TRANSMISSION__RPC_PORT:-9091}" \
        "$@"
