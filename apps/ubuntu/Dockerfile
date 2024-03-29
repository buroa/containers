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
    apk add --no-cache go upx \
    && go install -ldflags="-s -w" github.com/drone/envsubst/cmd/envsubst@latest \
    && upx /go/bin/envsubst

FROM docker.io/library/ubuntu:${VERSION}
ARG VERSION
ARG CHANNEL
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

# DEBIAN_FRONTEND: https://askubuntu.com/questions/972516/debian-frontend-environment-variable
# APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE: http://stackoverflow.com/questions/48162574/ddg#49462622
ENV \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
    UMASK="0002" \
    TZ="Etc/UTC"

# hadolint ignore=DL3002
USER root

RUN \
    adduser kah \
        --uid 568 \
        --group \
        --system \
        --disabled-password \
        --no-create-home \
    && \
    mkdir -p /config \
    && chown -R kah:kah /config \
    && chmod -R 775 /config

WORKDIR /app

# hadolint ignore=DL3008,DL3015
RUN \
    set -eux \
    && echo 'APT::Install-Recommends "false";' >/etc/apt/apt.conf.d/00recommends \
    && echo 'APT::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends \
    && echo 'APT::Get::Install-Recommends "false";' >>/etc/apt/apt.conf.d/00recommends \
    && echo 'APT::Get::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends \
    && \
    apt-get -qq update \
    && \
    apt-get install -y \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        dnsutils \
        iputils-ping \
        jo \
        jq \
        locales \
        moreutils \
        pv \
        tzdata \
        vim-tiny \
        unzip \
        wget \
    && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && ln -s /usr/bin/vim.tiny /usr/local/bin/vi \
    && ln -s /usr/bin/vim.tiny /usr/local/bin/vim \
    && ln -s /usr/bin/vim.tiny /usr/local/bin/nano \
    && ln -s /usr/bin/vim.tiny /usr/local/bin/emacs \
    && ln -s /usr/bin/catatonit /usr/bin/tini \
    && chown -R kah:kah /app \
    && \
    printf "/bin/bash /scripts/greeting.sh\n" >> /etc/bash.bashrc \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /var/tmp/*

ENV LANG en_US.UTF-8

VOLUME ["/config"]
COPY ./apps/ubuntu/scripts /scripts
COPY --from=builder /go/bin/envsubst /usr/local/bin/envsubst

ENTRYPOINT [ "/usr/bin/catatonit", "--" ]
