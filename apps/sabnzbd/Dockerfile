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
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

ENV SABNZBD__PORT=8080

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        curl \
        jq \
        nano \
        p7zip \
        tzdata \
    && \
    apk add --no-cache --virtual=.build-deps \
        build-base \
        cargo \
        libffi-dev \
        musl-dev \
        openssl-dev \
    && \
    mkdir -p /app \
    && \
    curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${VERSION}/SABnzbd-${VERSION}-src.tar.gz" \
        | tar xzf - -C /app --strip-components=1 \
    && \
    pip install uv \
    && \
    uv pip install --system --requirement /app/requirements.txt \
    && \
    chown -R root:root /app \
    && chmod -R 755 /app \
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

COPY ./apps/sabnzbd/sabnzbd.ini /app/sabnzbd.ini
COPY ./apps/sabnzbd/entrypoint.sh /entrypoint.sh
COPY --from=ghcr.io/buroa/par2cmdline-turbo:1.1.1 /usr/local/bin/par2 /usr/local/bin/par2
RUN ln -s /usr/local/bin/par2 /usr/local/bin/par2create \
    && ln -s /usr/local/bin/par2 /usr/local/bin/par2repair \
    && ln -s /usr/local/bin/par2 /usr/local/bin/par2verify
COPY --from=ghcr.io/linuxserver/unrar:7.0.7 /usr/bin/unrar-alpine /usr/bin/unrar
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/sabnzbd/sabnzbd"
