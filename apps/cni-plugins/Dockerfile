FROM docker.io/library/alpine:3.21

ARG TARGETARCH
ARG VERSION

ENV \
    CNI_BIN=/opt/cni

USER root

#hadolint ignore=DL3018,DL3013,DL3059,DL4006
RUN \
    apk add --no-cache \
        catatonit \
        curl \
        tar \
    && mkdir -p /cni \
    && curl -fsSL "https://github.com/containernetworking/plugins/releases/download/v${VERSION}/cni-plugins-linux-${TARGETARCH}-v${VERSION}.tgz" \
        | tar xzf - -C /cni --strip-components=1

COPY ./apps/cni-plugins/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/containernetworking/plugins"
