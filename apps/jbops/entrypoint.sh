#!/usr/bin/env bash
#shellcheck disable=SC2086

exec \
    /usr/local/bin/python \
        "/app/${JBOPS__SCRIPT_PATH}" \
        "$@"
