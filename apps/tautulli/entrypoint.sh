#!/usr/bin/env bash

#shellcheck disable=SC2086
exec \
    /usr/local/bin/python \
        /app/Tautulli.py \
        --nolaunch \
        --config /config/config.ini \
        --datadir /config \
        "$@"
