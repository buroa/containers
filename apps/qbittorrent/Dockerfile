FROM docker.io/library/alpine:3.20

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV QBITTORRENT__PORT=8080 \
    QBITTORRENT__BT_PORT=50413

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3059
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        curl \
        geoip \
        jq \
        nano \
        p7zip \
        python3 \
        tzdata \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH="x86_64" ;; \
        'linux/arm64') export ARCH="aarch64" ;; \
    esac \
    && \
    mkdir -p /app \
    && \
    case "${CHANNEL}" in \
        'stable') \
            export RELEASE=$(curl -sL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -r '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"') \
            && curl -fsSL -o /app/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${RELEASE}/${ARCH}-qbittorrent-nox" \
        ;; \
        'beta') \
            export RELEASE=$(curl -sL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -r '. | "release-\(.qbittorrent)_v\(.libtorrent_2_0)"') \
            && curl -fsSL -o /app/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${RELEASE}/${ARCH}-qbittorrent-nox" \
        ;; \
    esac \
    && \
    chown -R root:root /app/qbittorrent-nox \
    && chmod -R 755 /app/qbittorrent-nox \
    && rm -rf /tmp/*

COPY ./apps/qbittorrent/scripts/config.py /scripts/config.py
COPY ./apps/qbittorrent/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/qbittorrent/qBittorrent"
