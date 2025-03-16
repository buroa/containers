FROM docker.io/library/alpine:3.21

ARG TARGETPLATFORM
ARG VERSION

USER root
WORKDIR /app

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        postgresql17-client="${VERSION}"

COPY ./entrypoint.sh /entrypoint.sh

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/postgres/postgres"
