#!/usr/bin/env bash

#shellcheck disable=SC2086
exec \
    python \
        /app/Tautulli.py \
        --nolaunch \
        --config /config/config.ini \
        --datadir /config \
        "$@"
