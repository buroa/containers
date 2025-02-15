FROM docker.io/library/golang:1.24-alpine AS build-env

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /build

RUN \
    set -ex \
    && apk upgrade --no-cache --available \
    && apk add --no-cache build-base git \
    && git clone --recurse-submodules -j8 --branch v${VERSION} https://github.com/foxcpp/maddy.git .

ADD ./apps/maddy/patches/0001-feat-maddy-add-smtp-login-auth.patch ./patches/0001-feat-maddy-add-smtp-login-auth.patch

ENV CGO_ENABLED=1

RUN \
    git apply -v ./patches/0001-feat-maddy-add-smtp-login-auth.patch \
    && go build -ldflags "-s -w -X github.com/foxcpp/maddy.Version=${VERSION}" -o ./bin/maddy ./cmd/maddy \
    && chmod +x bin/maddy

FROM docker.io/library/alpine:3.21

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        curl \
        nano \
        tzdata \
    && rm -rf /tmp/*

COPY ./apps/maddy/entrypoint.sh /entrypoint.sh
COPY --from=build-env /build/bin/maddy /usr/local/bin/maddy
COPY --from=build-env /build/maddy.conf.docker /data/maddy.conf

USER nobody:nogroup
WORKDIR /data
VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/foxcpp/maddy"
