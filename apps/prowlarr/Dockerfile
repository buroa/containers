FROM ghcr.io/buroa/alpine:rolling@sha256:3b88053f744bb11a0b757ecc22f73b2ebf874bb9b2d7bb1f78d60484a69ce0b7

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    COMPlus_EnableDiagnostics="0" \
    PROWLARR__INSTANCE_NAME="Prowlarr" \
    PROWLARR__BRANCH="${CHANNEL}" \
    PROWLARR__PORT="9696" \
    PROWLARR__ANALYTICS_ENABLED="False"

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates icu-libs libintl sqlite-libs xmlstarlet

#hadolint ignore=DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    mkdir -p /app/bin \
    && \
    curl -fsSL "https://prowlarr.servarr.com/v1/update/${PROWLARR__BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=${ARCH}" \
        | tar xzf - -C /app/bin --strip-components=1 \
    && \
    rm -rf \
        /app/bin/Prowlarr.Update \
    && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[buroa](https://github.com/buroa)\n" "${PROWLARR__BRANCH}" "${VERSION}" > /app/package_info \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah
COPY ./apps/prowlarr/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/prowlarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/Prowlarr/Prowlarr"
