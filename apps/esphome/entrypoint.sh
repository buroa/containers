#!/bin/sh

PLATFORMIO_CORE_DIR=${PLATFORMIO_CORE_DIR:-/cache/pio}
ESPHOME_BUILD_PATH=${ESPHOME_BUILD_PATH:-/cache/build}
ESPHOME_DATA_DIR=${ESPHOME_DATA_DIR:-/cache/data}

# Make sure cache folders exist
mkdir -p "${PLATFORMIO_CORE_DIR}"
mkdir -p "${ESPHOME_BUILD_PATH}"
mkdir -p "${ESPHOME_DATA_DIR}"

# Prune PIO files
pio system prune --force

# Launch ESPHome
exec /usr/local/bin/esphome "$@"
