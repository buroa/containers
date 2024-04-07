FROM ghcr.io/buroa/alpine:rolling@sha256:3b88053f744bb11a0b757ecc22f73b2ebf874bb9b2d7bb1f78d60484a69ce0b7

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates postgresql16-client~"${VERSION}"

USER kah

COPY ./apps/postgres-init/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/postgres/postgres"
