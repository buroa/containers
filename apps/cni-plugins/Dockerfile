FROM docker.io/library/alpine:3.21

ARG TARGETARCH
ARG VERSION

USER root

#hadolint ignore=DL3018,DL3013,DL3059,DL4006
RUN \
    apk add --no-cache \
        curl \
        tar \
    && mkdir -p /plugins /host/opt/cni/bin \
    && curl -fsSL "https://github.com/containernetworking/plugins/releases/download/v${VERSION}/cni-plugins-linux-${TARGETARCH}-v${VERSION}.tgz" \
        | tar xzf - -C /plugins --strip-components=1 \
    && cp /plugins/* /host/opt/cni/bin
