FROM docker.io/nvidia/cuda:12.4.1-devel-ubuntu22.04 as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /build

RUN \
    apt-get -qq update \
    && \
    apt-get -qq install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        ccache \
        cmake \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && \
    git clone --recurse-submodules -j8 --branch v${VERSION} https://github.com/ollama/ollama.git .

FROM builder as builder-llm
WORKDIR /build/llm/generate

FROM builder-llm as builder-cpu
RUN CUDA_LIB_DIR="/noexist" OLLAMA_SKIP_STATIC_GENERATE="1" OLLAMA_CPU_TARGET="cpu" ./gen_linux.sh
FROM builder-llm as builder-cuda
RUN OLLAMA_SKIP_STATIC_GENERATE="1" OLLAMA_SKIP_CPU_GENERATE="1" ./gen_linux.sh
FROM builder-llm as builder-static
RUN CUDA_LIB_DIR="/noexist" OLLAMA_CPU_TARGET="static" ./gen_linux.sh

FROM builder as builder-final

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /build

COPY --from=builder-cpu /build/llm/build/linux llm/build/linux
COPY --from=builder-cuda /build/llm/build/linux llm/build/linux
COPY --from=builder-static /build/llm/build/linux llm/build/linux

COPY --from=docker.io/library/golang:1.22.2-bookworm /usr/local/go/ /usr/local/go/

ENV CGO_ENABLED="1" \
    PATH="/usr/local/go/bin:${PATH}"

RUN ls -la llm/build/linux/arm64_static

RUN go build -ldflags "-s -w \
        -X github.com/ollama/ollama/version.Version=${VERSION} \
        -X github.com/ollama/ollama/server.mode=release" \
    -o bin/ollama .

FROM docker.io/library/ubuntu:24.04

ENV UMASK="0002" \
    TZ="Etc/UTC"
ENV OLLAMA_HOST="0.0.0.0"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,utility" \
    NVIDIA_VISIBLE_DEVICES="all"

USER root
WORKDIR /root/.ollama

RUN \
    apt-get -qq update \
    && \
    apt-get -qq install -y --no-install-recommends --no-install-suggests \
        bash \
        ca-certificates \
        catatonit \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder-final /build/bin/ollama /usr/local/bin/ollama
COPY ./apps/ollama/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/ollama/ollama"
