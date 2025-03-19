#!/usr/bin/env bash

CONFIG_FILE="/config/nzbget.conf"

if [[ ! -f "${CONFIG_FILE}" ]]; then
    cp /app/nzbget.conf "${CONFIG_FILE}"
    sed -i \
        -e "s|^MainDir=.*|MainDir=/config/downloads|g" \
        -e "s|^QueueDir=.*|QueueDir=/config/queue|g" \
        -e "s|^LockFile=.*|LockFile=/config/nzbget.lock|g" \
        -e "s|^LogFile=.*|LogFile=/config/nzbget.log|g" \
        -e "s|^ShellOverride=.*|ShellOverride=.py=/usr/bin/python3;.sh=/bin/bash|g" \
        "${CONFIG_FILE}"
fi

#shellcheck disable=SC2086
exec \
    /app/nzbget \
        --server \
        --option "OutputMode=log" \
        --configfile "${CONFIG_FILE}" \
        "$@"
