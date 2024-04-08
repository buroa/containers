FROM docker.io/library/python:3.11-alpine

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

ENV TAUTULLI_DOCKER="True"

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        curl \
        jq \
        nano \
        tzdata \
    && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        cargo \
        libffi-dev \
        musl-dev \
        openssl-dev \
    && \
    pip install uv \
    && \
    uv pip install --system \
        --requirement "https://raw.githubusercontent.com/Tautulli/tautulli-baseimage/python3/requirements.txt" \
    && \
    mkdir -p /app \
    && \
    curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v${VERSION}.tar.gz" | tar xzf - -C /app --strip-components 1 \
    && \
    echo "v${VERSION}" > /app/version.txt \
    && \
    echo "${CHANNEL}" > /app/branch.txt \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

COPY ./apps/tautulli/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/Tautulli/Tautulli"
