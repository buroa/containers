#!/usr/bin/env bash
#shellcheck disable=SC2086

exec \
    /app/bin/Radarr \
        --nobrowser \
        --data=/config \
        "$@"
