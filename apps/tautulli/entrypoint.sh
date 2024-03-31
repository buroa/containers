#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

#shellcheck disable=SC2086
exec \
    /usr/bin/python3 \
        /app/Tautulli.py \
        --nolaunch \
        --config /config/config.ini \
        --datadir /config \
        "$@"
