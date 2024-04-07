ARG VERSION
FROM docker.io/library/golang:1.22-alpine as builder
ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG TARGETPLATFORM
ENV CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT}
#hadolint ignore=DL3018
RUN \
    apk add --no-cache upx \
    && go install -ldflags="-s -w" github.com/drone/envsubst/cmd/envsubst@latest \
    && upx /go/bin/envsubst

FROM docker.io/library/python:3.12-alpine

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    HOMEASSISTANT_WHEELS="https://wheels.home-assistant.io/musllinux/" \
    PYTHONPATH="${PYTHONPATH}:/pip-packages" \
    HOME="/config"

ENV UMASK="0002" \
    TZ="Etc/UTC"

WORKDIR /tmp

#hadolint ignore=DL3018,DL3013,DL3059,DL4006
RUN \
    apk add --no-cache \
        bash \
        bind-tools \
        bluez \
        bluez-deprecated \
        bluez-libs \
        ca-certificates \
        catatonit \
        coreutils \
        cups-libs \
        curl \
        eudev-libs \
        ffmpeg \
        git \
        iputils \
        jo \
        jq \
        libcap \
        libturbojpeg \
        libstdc++ \
        libxslt \
        mariadb-connector-c \
        mariadb-connector-c-dev \
        moreutils \
        nano \
        openssh-client \
        openssl \
        postgresql-libs \
        socat \
        tiff \
        tzdata \
        unzip \
        util-linux \
        wget \
    && \
    apk add --no-cache --virtual=.build-deps \
        autoconf \
        build-base \
        cargo \
        cmake \
        cups-dev \
        eudev-dev \
        ffmpeg-dev \
        glib-dev \
        jpeg-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        postgresql-dev \
        unixodbc-dev \
    && \
    pip install uv \
    && \
    curl -fsSL "https://github.com/home-assistant/core/archive/${VERSION}.tar.gz" \
        | tar xzf - -C /tmp --strip-components=1 \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            export ARCH='amd64'; \
        ;; \
        'linux/arm64') \
            export ARCH='aarch64'; \
        ;; \
    esac \
    && \
    HOME_ASSISTANT_BASE=$(curl -fsSL "https://raw.githubusercontent.com/home-assistant/core/${VERSION}/build.yaml" | grep "${ARCH}: " | cut -d ":" -f3) \
    && \
    uv pip install --system --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        --requirement "https://raw.githubusercontent.com/home-assistant/docker/${HOME_ASSISTANT_BASE}/requirements.txt" \
    && \
    uv pip install --system --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        --requirement requirements_all.txt \
    && \
    uv pip install --system --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        homeassistant=="${VERSION}" \
    && \
    addgroup -S kah --gid 568 \
        && adduser -S kah -G kah --uid 568 \
    && \
    mkdir -p /config \
    && chown -R kah:kah /config \
    && chmod -R 775 /config \
    && printf "/bin/bash /scripts/greeting.sh\n" > /etc/profile.d/greeting.sh \
    && printf "umask %d\n" "${UMASK}" > /etc/profile.d/umask.sh \
    && ln -s /usr/bin/vi /usr/local/bin/vi \
    && ln -s /usr/bin/vi /usr/local/bin/vim \
    && ln -s /usr/bin/nano /usr/local/bin/nano \
    && ln -s /usr/bin/nano /usr/local/bin/neovim \
    && ln -s /usr/bin/nano /usr/local/bin/emacs \
    && ln -s /usr/bin/catatonit /sbin/tini \
    && \
    apk del --purge .build-deps \
    && \
    rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

COPY --from=builder /go/bin/envsubst /usr/local/bin/envsubst
COPY ./apps/home-assistant/scripts /scripts
VOLUME ["/config"]

WORKDIR /app
USER kah
COPY ./apps/home-assistant/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/home-assistant/core"
