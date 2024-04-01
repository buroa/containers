#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

#shellcheck disable=SC2086
exec \
    /usr/local/bin/cloudflared \
        tunnel \
            --config /etc/cloudflared/config/config.yaml \
            --run ${TUNNEL_ID} \
                "$@"
