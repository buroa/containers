#!/usr/bin/env bash

#shellcheck disable=SC2086
exec \
    /usr/local/bin/maddy \
    -config /data/maddy.conf \
        run \
        "$@"
