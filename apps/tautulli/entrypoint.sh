#!/usr/bin/env bash
#shellcheck disable=SC2086

exec \
    /usr/local/bin/python \
        /app/Tautulli.py \
        --nolaunch \
        --port ${TAUTULLI__PORT} \
        --config /config/config.ini \
        --datadir /config \
        "$@"
