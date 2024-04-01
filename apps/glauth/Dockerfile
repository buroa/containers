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
    GOARM=${TARGETVARIANT} \
    GOPATH=/go

ENV PATH=${GOPATH}/bin:${PATH}

RUN \
    apk add --no-cache git go upx \
    && go install github.com/glauth/glauth/v2@v${VERSION} \
    && upx /go/bin/glauth

FROM ghcr.io/buroa/alpine:rolling@sha256:f7d7798d8e6c5c3df13d393c50a3a315147d2101d7f4ee7300fac9f9d244860b

USER kah
COPY --from=builder /go/bin/glauth /usr/local/bin/glauth
COPY ./apps/glauth/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/glauth/glauth"
