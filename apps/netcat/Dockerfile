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
        netcat-openbsd~"${VERSION}"

ENTRYPOINT ["/usr/bin/catatonit", "--", "nc"]
