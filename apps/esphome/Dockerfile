FROM docker.io/library/python:3.13.2-alpine

ARG VERSION

LABEL org.opencontainers.image.source="https://github.com/esphome/esphome"

ENV \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1 \
  PIP_ROOT_USER_ACTION=ignore \
  PIP_NO_CACHE_DIR=1 \
  PIP_DISABLE_PIP_VERSION_CHECK=1 \
  PIP_BREAK_SYSTEM_PACKAGES=1 \
  UV_SYSTEM_PYTHON=true \
  CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
  HOME="/config" \
  PLATFORMIO_CORE_DIR=/cache/pio \
  ESPHOME_BUILD_PATH=/cache/build \
  ESPHOME_DATA_DIR=/cache/data

USER root
WORKDIR /app

RUN \
  apk add --no-cache \
    build-base \
    catatonit \
    gcompat \
    git \
  && pip install uv \
  && uv pip install --find-links "https://wheels.home-assistant.io/musllinux/" "setuptools" "esphome[displays]==${VERSION}" \
  && mkdir /cache \
  && chown nobody:nogroup /cache \
  && rm -rf \
    /tmp/* \
    /wheels

COPY ./entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config", "/cache"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
CMD ["dashboard", "/config"]
