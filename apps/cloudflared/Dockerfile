FROM docker.io/library/alpine:3.19 as builder

ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG TARGETPLATFORM

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT}

WORKDIR /build

RUN \
    apk add --no-cache bash git go make upx \
    && git clone --depth 1 --branch ${VERSION} https://github.com/cloudflare/cloudflared.git . \
    && make cloudflared \
    && upx cloudflared

FROM ghcr.io/buroa/alpine:rolling@sha256:f7d7798d8e6c5c3df13d393c50a3a315147d2101d7f4ee7300fac9f9d244860b

USER kah
COPY --from=builder /build/cloudflared /usr/local/bin/cloudflared
COPY ./apps/cloudflared/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/cloudflare/cloudflared"
