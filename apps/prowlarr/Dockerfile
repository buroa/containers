FROM docker.io/library/alpine:3.21

ARG TARGETPLATFORM
ARG VENDOR
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV \
    DOTNET_EnableDiagnostics="0" \
    PROWLARR__UPDATE__BRANCH="develop"

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3059
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        icu-libs \
        jo \
        jq \
        libintl \
        nano \
        sqlite-libs \
        trurl \
        tzdata \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && mkdir -p /app/bin \
    && curl -fsSL "https://prowlarr.servarr.com/v1/update/${PROWLARR__UPDATE__BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=${ARCH}" \
        | tar xzf - -C /app/bin --strip-components=1 \
    && printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[%s](https://github.com/%s)\n" "${PROWLARR__UPDATE__BRANCH}" "${VERSION}" "${VENDOR}" "${VENDOR}" > /app/package_info \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /tmp/*  /app/bin/Prowlarr.Update

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/app/bin/Prowlarr", "--nobrowser", "--data=/config"]

LABEL org.opencontainers.image.source="https://github.com/Prowlarr/Prowlarr"
