#!/usr/bin/env bash

# Make sure the config and log directory exist
mkdir -p /config/logs

# Install HACS if requested
if [[ "${HOME_ASSISTANT__HACS_INSTALL}" == "true" ]]; then
    curl -sfSL https://hacs.xyz/install | bash -
fi

exec \
    /usr/local/bin/hass \
        --config /config \
        --log-file /config/logs/home-assistant.log \
        "$@"
