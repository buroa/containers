FROM docker.io/library/golang:1.22-alpine as envsubst

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

FROM docker.io/library/alpine:3.19

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    COMPlus_EnableDiagnostics="0" \
    PROWLARR__INSTANCE_NAME="Prowlarr" \
    PROWLARR__BRANCH="${CHANNEL}" \
    PROWLARR__PORT="9696" \
    PROWLARR__ANALYTICS_ENABLED="False"

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3059
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        curl \
        icu-libs \
        jq \
        libintl \
        nano \
        sqlite-libs \
        tzdata \
        xmlstarlet \
    && \
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
    rm -rf /app/bin/Prowlarr.Update \
    && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[buroa](https://github.com/buroa)\n" "${PROWLARR__BRANCH}" "${VERSION}" > /app/package_info \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

COPY ./apps/prowlarr/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/prowlarr/entrypoint.sh /entrypoint.sh
COPY --from=envsubst /go/bin/envsubst /usr/local/bin/envsubst
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/Prowlarr/Prowlarr"
