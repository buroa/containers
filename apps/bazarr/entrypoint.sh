#!/usr/bin/env bash
#shellcheck disable=SC2086

exec \
    /usr/local/bin/python \
        /app/bin/bazarr.py \
            --no-update \
            --config /config \
            --port ${BAZARR__PORT} \
            "$@"
