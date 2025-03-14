FROM docker.io/library/python:3.12-alpine

ARG TARGETPLATFORM
ARG VENDOR
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

ENV \
    BAZARR__PORT=6767 \
    BAZARR_PACKAGE_AUTHOR=${VENDOR} \
    BAZARR_PACKAGE_VERSION=${VERSION} \
    BAZARR_VERSION=${VERSION}

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        ffmpeg \
        jo \
        jq \
        libxml2 \
        libxslt \
        mediainfo \
        nano \
        trurl \
        tzdata \
        unzip \
        libpq \
    && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        cargo \
        libffi-dev \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
    && \
    curl -fsSL -o /tmp/app.zip "https://github.com/morpheus65535/bazarr/releases/download/${VERSION}/bazarr.zip" \
    && unzip -q /tmp/app.zip -d /app/bin \
    && rm -rf /app/bin/bin \
    && pip install --no-cache-dir \
        --requirement /app/bin/requirements.txt \
        --requirement /app/bin/postgres-requirements.txt \
    && chown -R root:root /app && chmod -R 755 /app \
    && apk del --purge .build-deps \
    && rm -rf /root/.cache /root/.cargo /tmp/*

COPY ./entrypoint.sh /entrypoint.sh
COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/morpheus65535/bazarr"
