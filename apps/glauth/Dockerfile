ARG VERSION
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
ENV PATH $GOPATH/bin:$PATH
#hadolint ignore=DL3018
RUN \
    apk add --no-cache git go upx \
    && go install github.com/glauth/glauth/v2@v${VERSION} \
    && upx /go/bin/glauth

FROM docker.io/library/alpine:3.19.1
ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=builder /go/bin/glauth /usr/local/bin/glauth

ENTRYPOINT ["/usr/local/bin/glauth"]

LABEL org.opencontainers.image.source="https://github.com/glauth/glauth"
