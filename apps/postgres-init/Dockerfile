FROM docker.io/library/alpine:3.21

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root
WORKDIR /app

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        postgresql16-client~"${VERSION}"

COPY ./apps/postgres-init/entrypoint.sh /entrypoint.sh

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/postgres/postgres"
