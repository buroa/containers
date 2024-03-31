#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

# Make sure the config and log directory exist
mkdir -p /config/logs

# Install HACS if requested
if [[ "${HOME_ASSISTANT__HACS_INSTALL}" == "true" ]]; then
    wget -O - https://get.hacs.xyz | bash -
fi

exec \
    /usr/local/bin/hass \
        --config /config \
        --log-file /config/logs/home-assistant.log \
        "$@"
