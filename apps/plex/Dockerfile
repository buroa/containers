ARG VERSION
FROM docker.io/library/golang:1.22 as envsubst
ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG TARGETPLATFORM
ENV CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT}
RUN go install -ldflags="-s -w" github.com/drone/envsubst/cmd/envsubst@latest

FROM docker.io/library/ubuntu:22.04

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="DontWarn"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/config/Library/Application Support" \
    PLEX_MEDIA_SERVER_HOME="/usr/lib/plexmediaserver" \
    PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6" \
    PLEX_MEDIA_SERVER_INFO_VENDOR="Docker" \
    PLEX_MEDIA_SERVER_INFO_DEVICE="Docker Container (buroa)"

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    apt-get -qq update \
    && \
    apt-get -qq install --no-install-recommends --no-install-suggests -y \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        dnsutils \
        iputils-ping \
        jo \
        jq \
        moreutils \
        tzdata \
        unzip \
        uuid-runtime \
        vim-tiny \
        xmlstarlet \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            export ARCH='amd64'; \
        ;; \
        'linux/arm64') \
            export ARCH='arm64'; \
        ;; \
    esac \
    && \
    curl -fsSL -o /tmp/plex.deb \
        "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_${ARCH}.deb" \
    && \
    dpkg -i --force-confold /tmp/plex.deb \
    && chmod -R 755 "${PLEX_MEDIA_SERVER_HOME}" \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /etc/default/plexmediaserver \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/

WORKDIR "${PLEX_MEDIA_SERVER_HOME}"

COPY --from=envsubst /go/bin/envsubst /usr/local/bin/envsubst

COPY ./apps/plex/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/usr/bin/catatonit", "--" ]
CMD ["/entrypoint.sh"]
