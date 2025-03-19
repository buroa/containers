FROM docker.io/library/alpine:3.21

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV HOME=/config \
    XDG_CONFIG_HOME=/config \
    XDG_DATA_HOME=/config \
    TRANSMISSION__RPC_PORT=9091 \
    TRANSMISSION_WEB_HOME=/usr/share/transmission/public_html

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        findutils \
        geoip \
        jo \
        jq \
        nano \
        p7zip \
        python3 \
        transmission-daemon="${VERSION}" \
        transmission-cli \
        transmission-remote \
        trurl \
        tzdata \
    && rm -rf /tmp/*

COPY ./settings.json.tpl /settings.json.tpl
COPY ./entrypoint.sh /entrypoint.sh

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/transmission/transmission"
