FROM golang:1.21.5 as builder

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
    git clone --depth 1 --branch ${VERSION} https://github.com/cloudflare/cloudflared.git .

RUN .teamcity/install-cloudflare-go.sh

ENV PATH=/tmp/go/bin:${PATH}

RUN make cloudflared

FROM gcr.io/distroless/base-debian11:nonroot

COPY --from=builder --chown=nonroot /build/cloudflared /usr/local/bin/cloudflared

USER nonroot
ENTRYPOINT ["/usr/local/bin/cloudflared"]

LABEL org.opencontainers.image.source="https://github.com/cloudflare/cloudflared"
