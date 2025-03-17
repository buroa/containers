#!/usr/bin/env bash
#shellcheck disable=SC2086

exec \
    python3 -m homeassistant \
        --config /config \
        "$@"
