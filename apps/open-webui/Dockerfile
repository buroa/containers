FROM docker.io/library/node:alpine as build

ARG VERSION

WORKDIR /app

RUN \
    apk add --no-cache \
        curl \
    && \
    curl -fsSL "https://chroma-onnx-models.s3.amazonaws.com/all-MiniLM-L6-v2/onnx.tar.gz" \
        | tar xzf - -C /app \
    && \
    curl -fsSL "https://github.com/open-webui/open-webui/archive/refs/tags/v${VERSION}.tar.gz" \
        | tar xzf - -C /app --strip-components 1 \
    && npm ci \
    && npm run build

FROM docker.io/library/python:3.11-bookworm

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV ENV=prod \
    PORT="" \
    OLLAMA_BASE_URL="/ollama" \
    OPENAI_API_BASE_URL="" \
    OPENAI_API_KEY="" \
    WEBUI_SECRET_KEY="" \
    WEBUI_AUTH_TRUSTED_EMAIL_HEADER="" \
    SCARF_NO_ANALYTICS=true \
    DO_NOT_TRACK=true

ENV LITELLM_LOCAL_MODEL_COST_MAP="True"

ENV WHISPER_MODEL="base" \
    WHISPER_MODEL_DIR="/app/backend/data/cache/whisper/models"

ENV RAG_EMBEDDING_MODEL="all-MiniLM-L6-v2" \
    RAG_EMBEDDING_MODEL_DEVICE_TYPE="cpu" \
    RAG_EMBEDDING_MODEL_DIR="/app/backend/data/cache/embedding/models" \
    SENTENCE_TRANSFORMERS_HOME=$RAG_EMBEDDING_MODEL_DIR

ENV NVIDIA_DRIVER_CAPABILITIES="compute,utility" \
    NVIDIA_VISIBLE_DEVICES="all"

ENV UMASK="0002" \
    TZ="Etc/UTC"

WORKDIR /app/backend

#hadolint ignore=DL3018,DL3013
RUN \
    apt-get -qq update \
    && \
    apt-get -qq install -y --no-install-recommends --no-install-suggests \
        catatonit \
        ffmpeg \
        libsm6 \
        libxext6 \
        netcat-openbsd \
        pandoc \
    && \
    pip install uv \
    && \
    uv pip install --system \
        --requirement "https://raw.githubusercontent.com/open-webui/open-webui/v${VERSION}/backend/requirements.txt" \
    && \
    uv pip install --system \
        torch \
        torchvision \
        torchaudio \
    && \
    mkdir -p /app \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/

COPY --from=build /app/backend /app/backend
COPY --from=build /app/onnx /root/.cache/chroma/onnx_models/all-MiniLM-L6-v2/onnx
COPY --from=build /app/build /app/build
COPY --from=build /app/CHANGELOG.md /app/CHANGELOG.md
COPY --from=build /app/package.json /app/package.json

COPY ./apps/open-webui/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/open-webui/open-webui"