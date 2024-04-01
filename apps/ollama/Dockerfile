FROM docker.io/library/golang:1.22.1-bookworm as golang

FROM docker.io/nvidia/cuda:12.3.2-devel-ubuntu22.04 as builder

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

WORKDIR /build

RUN \
    apt-get update \
    && apt-get install --no-install-recommends -y cmake git

RUN \
    git clone --depth 1 --branch v${VERSION} https://github.com/ollama/ollama.git .

COPY --from=golang /usr/local/go/ /usr/local/go/

ENV \
    PATH=/usr/local/go/bin:${PATH} \
    CMAKE_DEFS="-DLLAMA_CUDA_FORCE_MMQ=off" \
    OLLAMA_SKIP_CPU_GENERATE=1

RUN \
    go generate ./... \
    && go build \
        -ldflags \
            "-s -w \
            -X github.com/ollama/ollama/version.Version=${VERSION} \
            -X github.com/ollama/ollama/server.mode=release" \
    -o bin/ollama .

FROM ghcr.io/buroa/ubuntu:jammy-20240227@sha256:7606a9fe80ba47b2958eed8515d7f755c6b4939f37ab8329813ee6dce3fc1d6c

ENV OLLAMA_HOST 0.0.0.0
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all

COPY --from=builder --chown=kah /build/bin/ollama /usr/local/bin/ollama

USER kah
WORKDIR /home/kah/.ollama
ENTRYPOINT ["/usr/local/bin/ollama"]
CMD ["serve"]

LABEL org.opencontainers.image.source="https://github.com/ollama/ollama"
