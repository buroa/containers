FROM docker.io/library/node:16-alpine3.18 AS betanin-client
WORKDIR /src
RUN apk add git && \
    git clone https://github.com/sentriz/betanin.git . && \
    cd /src/betanin_client && \
    npm install && \
    PRODUCTION=true npm run-script build

FROM docker.io/library/python:3.13-alpine

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
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

ENV HOME=/config \
    MODE=betanin \
    BETANIN_HOST=0.0.0.0 \
    BETANIN_PORT=4030 \
    BEETSDIR=/config/.config/beets \
    FPCALC=/usr/bin/fpcalc

RUN \
    apk add --no-cache \
        bash \
        catatonit \
        coreutils \
        chromaprint \
        expat \
        ffmpeg \
        ffmpeg-libs \
        fftw \
        flac \
        gdbm \
        git \
        gst-plugins-good \
        gstreamer \
        imagemagick \
        jpeg \
        keyfinder-cli \
        lame \
        libev \
        libffi \
        libpng \
        mpg123 \
        openjpeg \
        sqlite-libs \
    && \
    apk add --no-cache --repository="https://dl-cdn.alpinelinux.org/alpine/edge/testing/" \
        mp3gain \
        mp3val \
    && \
    pip install uv \
    && \
    uv pip install \
        https://github.com/beetbox/beets/releases/download/${VERSION}/beets-${VERSION#*v}-py3-none-any.whl \
    && \
    uv pip install \
        git+https://github.com/sentriz/betanin.git

COPY --from=betanin-client /src/betanin_client/dist/ /src/betanin_client/dist/
COPY ./entrypoint.sh /entrypoint.sh
COPY ./config-beets.yaml /config-beets.yaml
COPY ./config-betanin.toml.tpl /config-betanin.toml.tpl

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/beetbox/beets"
