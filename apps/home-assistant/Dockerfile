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

FROM docker.io/library/python:3.12.2-alpine3.19

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

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        ca-certificates catatonit bash \
        bind-tools coreutils curl iputils jo \
        jq moreutils nano pv tzdata unzip \
        util-linux wget

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bluez \
        bluez-deprecated \
        bluez-libs \
        ca-certificates \
        cups-libs \
        eudev-libs \
        ffmpeg \
        git \
        libcap \
        libturbojpeg \
        libstdc++ \
        libxslt \
        mariadb-connector-c \
        mariadb-connector-c-dev \
        openssh-client \
        openssl \
        postgresql-libs \
        py3-pip \
        python3 \
        socat \
        tiff

#hadolint ignore=DL3018,DL3013,DL3059,DL4006
RUN \
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
        python3-dev \
        unixodbc-dev \
    && \
    pip install --upgrade \
        cython \
        pip \
        pyparsing \
        setuptools \
        wheel \
    && \
    curl -fsSL "https://github.com/home-assistant/core/archive/${VERSION}.tar.gz" \
        | tar xzf - -C /tmp --strip-components=1 \
    && \
    mkdir -p /pip-packages \
    && \
    pip install \
        --upgrade \
        --target /pip-packages \
        distlib \
    && \
    NUMPY_VERSION=$(grep "numpy" requirements_all.txt) \
    && \
    pip install --find-links "${HOMEASSISTANT_WHEELS}" \
        "${NUMPY_VERSION}" \
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
    pip install --no-index --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        --requirement "https://raw.githubusercontent.com/home-assistant/docker/${HOME_ASSISTANT_BASE}/requirements.txt" \
    && \
    pip install --find-links "${HOMEASSISTANT_WHEELS}" \
        --requirement requirements_all.txt \
    && \
    pip install --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        homeassistant=="${VERSION}" \
    && \
    pip install --find-links "${HOMEASSISTANT_WHEELS}" \
        pycups PySwitchbot \
    && \
    apk del --purge .build-deps \
    && \
    rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

#hadolint ignore=DL3018
RUN \
    addgroup -S kah --gid 568 \
        && adduser -S kah -G kah --uid 568 \
    && \
    mkdir -p /config \
    && chown -R kah:kah /config \
    && chmod -R 775 /config \
    && printf "/bin/bash /scripts/greeting.sh\n" > /etc/profile.d/greeting.sh \
    && printf "umask %d\n" "${UMASK}" > /etc/profile.d/umask.sh \
    && ln -s /usr/bin/vi   /usr/local/bin/vi \
    && ln -s /usr/bin/vi   /usr/local/bin/vim \
    && ln -s /usr/bin/nano /usr/local/bin/nano \
    && ln -s /usr/bin/nano /usr/local/bin/neovim \
    && ln -s /usr/bin/nano /usr/local/bin/emacs \
    && ln -s /usr/bin/catatonit /sbin/tini \
    && rm -rf /tmp/*

COPY --from=builder /go/bin/envsubst /usr/local/bin/envsubst
COPY ./apps/home-assistant/scripts /scripts
VOLUME ["/config"]

WORKDIR /app
USER kah
COPY ./apps/home-assistant/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/home-assistant/core"
