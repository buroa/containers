FROM docker.io/library/python:3.13.2-alpine

ARG TARGETARCH
ARG TARGETPLATFORM
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    UV_SYSTEM_PYTHON=true \
    UV_NO_CACHE=true \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    HOMEASSISTANT_WHEELS="https://wheels.home-assistant.io/musllinux/" \
    HOME="/config" \
    VENV_FOLDER="/config/.venv"

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3013,DL3059,DL4006
RUN \
    apk add --no-cache \
        bash \
        binutils \
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
        libjpeg-turbo-dev \
        libpcap-dev \
        libstdc++ \
        libxslt \
        mariadb-connector-c \
        mariadb-connector-c-dev \
        nano \
        openssh-client \
        openssl \
        postgresql-libs \
        socat \
        tiff \
        trurl \
        tzdata \
        unzip \
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
    uv pip install --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        --requirement "https://raw.githubusercontent.com/home-assistant/docker/${HOME_ASSISTANT_BASE}/requirements.txt" \
    && \
    uv pip install --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        --requirement /tmp/requirements_all.txt \
    && \
    uv pip install --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        homeassistant=="${VERSION}" \
    && curl -L https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_${TARGETARCH} --output /bin/go2rtc \
    && chmod +x /bin/go2rtc \
    && mkdir -p /config && chown nobody:nogroup -R /config \
    && apk del --purge .build-deps \
    && rm -rf /root/.cache /root/.cargo /tmp/*

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/usr/local/bin/hass", "--config", "/config"]

LABEL org.opencontainers.image.source="https://github.com/home-assistant/core"
