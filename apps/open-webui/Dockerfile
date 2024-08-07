FROM docker.io/library/node:22-alpine3.19 as frontend

ARG VERSION

WORKDIR /app

RUN \
    apk add --no-cache \
        curl \
    && \
    curl -fsSL "https://github.com/open-webui/open-webui/archive/refs/tags/v${VERSION}.tar.gz" \
        | tar xzf - -C /app --strip-components 1 \
    && npm ci \
    && npm run build

FROM docker.io/library/python:3.11-slim-bookworm

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ARG TORCH_LIB="/usr/local/lib/python3.11/site-packages/torch/lib" \
    CUDNN_LIB="/usr/local/lib/python3.11/site-packages/nvidia/cudnn/lib" \
    CUBLAS_LIB="/usr/local/lib/python3.11/site-packages/nvidia/cublas/lib"

ENV UMASK="0002" \
    TZ="Etc/UTC"

#hadolint ignore=DL3018,DL3013
RUN \
    apt-get -qq update \
    && \
    apt-get -qq install -y --no-install-recommends --no-install-suggests \
        catatonit \
        ffmpeg \
        g++ \
        libsm6 \
        libxext6 \
        netcat-openbsd \
        pandoc \
        sqlite3 \
    && \
    pip install uv \
    && \
    uv pip install --system --no-cache-dir --compile-bytecode \
        torch \
        torchvision \
        torchaudio \
    && \
    uv pip install --system --no-cache-dir --compile-bytecode \
        --requirement "https://raw.githubusercontent.com/open-webui/open-webui/v${VERSION}/backend/requirements.txt" \
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

ENV DO_NOT_TRACK="true" \
    ENV="prod" \
    HF_HOME="/app/backend/data/cache/embedding/models" \
    LITELLM_LOCAL_MODEL_COST_MAP="True" \
    OPENAI_API_BASE_URL="" \
    OPENAI_API_KEY="" \
    OLLAMA_BASE_URL="/ollama" \
    RAG_EMBEDDING_MODEL="BAAI/bge-m3" \
    RAG_EMBEDDING_MODEL_TRUST_REMOTE_CODE="true" \
    SCARF_NO_ANALYTICS="true" \
    SENTENCE_TRANSFORMERS_HOME="/app/backend/data/cache/embedding/models" \
    TRANSFORMERS_CACHE="/app/backend/data/cache/embedding/models" \
    WHISPER_MODEL="base" \
    WHISPER_MODEL_DIR="/app/backend/data/cache/whisper/models"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,utility" \
    NVIDIA_VISIBLE_DEVICES="all"

ENV LD_LIBRARY_PATH="${TORCH_LIB}:${CUDNN_LIB}:${CUBLAS_LIB}:${LD_LIBRARY_PATH}"

COPY ./apps/open-webui/scripts/models.py /models.py
RUN /models.py

COPY --from=frontend /app/build /app/build
COPY --from=frontend /app/CHANGELOG.md /app/CHANGELOG.md
COPY --from=frontend /app/package.json /app/package.json
COPY --from=frontend /app/backend /app/backend
COPY ./apps/open-webui/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/open-webui/open-webui"
