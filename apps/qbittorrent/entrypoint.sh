#!/usr/bin/env bash
#shellcheck disable=SC2086,SC2090

CONFIG_FILE="/config/qBittorrent/qBittorrent.conf"
LOG_FILE="/config/qBittorrent/logs/qbittorrent.log"

# Set environment variables (QBITTORRENT__PORT and QBITTORRENT__BT_PORT are deprecated)
export QBT_WEBUI_PORT="${QBITTORRENT__PORT:-$QBT_WEBUI_PORT}"
export QBT_TORRENTING_PORT="${QBITTORRENT__BT_PORT:-$QBT_TORRENTING_PORT}"

# Ensure the config file exists, copy default if missing
if [[ ! -f "${CONFIG_FILE}" ]]; then
    echo "Copying over default configuration ..."
    mkdir -p "${CONFIG_FILE%/*}"
    cp /app/qBittorrent.conf "${CONFIG_FILE}"
fi

# Set up log file to redirect to stdout
if [[ ! -f "${LOG_FILE}" ]]; then
    mkdir -p "${LOG_FILE%/*}"
    ln -sf /proc/self/fd/1 "${LOG_FILE}"
fi

# Execute qBittorrent
exec /app/qbittorrent-nox "$@"
