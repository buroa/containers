#!/usr/bin/env bash

if [[ "${HOME_ASSISTANT__HACS_INSTALL}" == "true" ]]; then
    curl -sfSL https://hacs.xyz/install | bash -
fi

exec \
    /usr/local/bin/hass \
        --config /config \
        "$@"
