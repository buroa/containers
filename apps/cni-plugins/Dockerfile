FROM docker.io/library/alpine:3.21

ARG TARGETARCH
ARG VERSION

ENV CNI_BIN_DIR=/host/opt/cni/bin

USER root

#hadolint ignore=DL3018,DL3013,DL3059,DL4006
RUN \
    apk add --no-cache \
        curl \
        rsync \
        tar \
    && mkdir -p /plugins \
    && curl -fsSL "https://github.com/containernetworking/plugins/releases/download/v${VERSION}/cni-plugins-linux-${TARGETARCH}-v${VERSION}.tgz" \
        | tar xzf - -C /plugins --strip-components=1

CMD rsync -av /plugins/* $CNI_BIN_DIR

LABEL org.opencontainers.image.source="https://github.com/containernetworking/plugins"
