FROM docker.io/library/node:21-alpine3.19 as build

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

ENV ENV=prod \
    PORT=8080

ENV OLLAMA_BASE_URL="/ollama" \
    OPENAI_API_BASE_URL=""

ENV OPENAI_API_KEY="" \
    WEBUI_SECRET_KEY="" \
    SCARF_NO_ANALYTICS=true \
    DO_NOT_TRACK=true

ENV LITELLM_LOCAL_MODEL_COST_MAP="True"

ENV WHISPER_MODEL="base" \
    WHISPER_MODEL_DIR="/app/backend/data/cache/whisper/models"

ENV RAG_EMBEDDING_MODEL="Alibaba-NLP/gte-large-en-v1.5" \
    RAG_RERANKING_MODEL="BAAI/bge-reranker-large" \
    SENTENCE_TRANSFORMERS_HOME="/app/backend/data/cache/embedding/models"

ENV HF_HOME="/app/backend/data/cache/embedding/models"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,utility" \
    NVIDIA_VISIBLE_DEVICES="all"

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root
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
        torch \
        torchvision \
        torchaudio \
    && \
    uv pip install --system \
        --requirement "https://raw.githubusercontent.com/open-webui/open-webui/v${VERSION}/backend/requirements.txt" \
    && \
    python -c "import os; from sentence_transformers import SentenceTransformer; SentenceTransformer(os.environ['RAG_EMBEDDING_MODEL'], device='cpu')" \
    && \
    python -c "import os; from sentence_transformers import CrossEncoder; CrossEncoder(os.environ['RAG_RERANKING_MODEL'], device='cpu')" \
    && \
    python -c "import os; from faster_whisper import WhisperModel; WhisperModel(os.environ['WHISPER_MODEL'], device='cpu', compute_type='int8', download_root=os.environ['WHISPER_MODEL_DIR'])" \
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

COPY --from=build /app/build /app/build
COPY --from=build /app/CHANGELOG.md /app/CHANGELOG.md
COPY --from=build /app/package.json /app/package.json
COPY --from=build /app/backend /app/backend
COPY ./apps/open-webui/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/open-webui/open-webui"
