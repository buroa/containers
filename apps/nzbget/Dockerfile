FROM docker.io/library/python:3.13-alpine

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV UMASK="0002" \
    TZ="Etc/UTC" \
    PATH="/app:${PATH}"

USER root
WORKDIR /app

#hadolint ignore=DL3013,DL3018
RUN \
    apk add --no-cache \
    bash \
    ca-certificates \
    catatonit \
    coreutils \
    curl \
    jo \
    jq \
    nano \
    p7zip \
    trurl \
    tzdata

RUN \
    curl -fsSL -o /tmp/nzbget.run \
        "https://github.com/nzbgetcom/nzbget/releases/download/v${VERSION}/nzbget-${VERSION}-bin-linux.run" \
    && \
    sh /tmp/nzbget.run --destdir /app \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

COPY ./entrypoint.sh /entrypoint.sh

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/nzbgetcom/nzbget"
