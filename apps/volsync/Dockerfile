FROM docker.io/library/golang:1.22-alpine as volsync

ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG TARGETPLATFORM

ENV CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT}

RUN go install -a -ldflags "-X=main.volsyncVersion=v${VERSION}" github.com/backube/volsync@v${VERSION}

FROM docker.io/library/alpine:3.20.0

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN \
    apk add --no-cache \
        acl \
        bash \
        ca-certificates \
        curl \
        coreutils \
        tzdata \
    && \
    curl -fsSL "https://github.com/backube/volsync/archive/refs/tags/v${VERSION}.tar.gz" \
        | tar xzf - -C /tmp --strip-components=1 \
    && mkdir -p /mover-rclone \
        && cp /tmp/mover-rclone/active.sh /mover-rclone/ \
        && chmod a+rx /mover-rclone/*.sh \
    && mkdir -p /mover-restic \
        && cp /tmp/mover-restic/entry.sh /mover-restic/ \
        && chmod a+rx /mover-restic/*.sh \
    && rm -rf /tmp/*

COPY --from=docker.io/rclone/rclone:1.66.0 /usr/local/bin/rclone /usr/local/bin/rclone
COPY --from=docker.io/restic/restic:0.16.4 /usr/bin/restic /usr/local/bin/restic
COPY --from=volsync /go/bin/volsync /manager
ENTRYPOINT ["/bin/bash"]

LABEL org.opencontainers.image.source="https://github.com/backube/volsync"
