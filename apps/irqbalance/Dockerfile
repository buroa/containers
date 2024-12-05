FROM docker.io/library/alpine:3.21

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        catatonit \
        irqbalance~"${VERSION}"

COPY ./apps/irqbalance/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/irqbalance/irqbalance"
