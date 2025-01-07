FROM docker.io/library/alpine:3.21

ARG TARGETARCH
ARG VERSION
ARG CHANNEL

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/config/Library/Application Support" \
    PLEX_MEDIA_SERVER_HOME="/usr/lib/plexmediaserver" \
    PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6" \
    PLEX_MEDIA_SERVER_INFO_VENDOR="Docker" \
    PLEX_MEDIA_SERVER_INFO_DEVICE="Docker Container (buroa)"

USER root

#hadolint ignore=DL3018,DL3059
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
        trurl \
        tzdata \
        uuidgen \
        xmlstarlet \
    && \
    apk add --no-cache --virtual=.build-deps \
        dpkg \
    && curl -fsSL -o /tmp/plex.deb \
        "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_${TARGETARCH}.deb" \
    && \
    dpkg-deb -x /tmp/plex.deb / \
    && chown -R root:root "${PLEX_MEDIA_SERVER_HOME}" \
    && chmod -R 755 "${PLEX_MEDIA_SERVER_HOME}" \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

COPY ./apps/plex/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
