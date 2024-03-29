FROM docker.io/library/golang:1.22.1-bookworm@sha256:d996c645c9934e770e64f05fc2bc103755197b43fd999b3aa5419142e1ee6d78 as golang

FROM docker.io/nvidia/cuda:12.3.2-devel-ubuntu22.04@sha256:6655d5fc2fb48580255a5021a81c379c325a457b74b77ac823ed67e4faa32aeb as builder

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
    OLLAMA_SKIP_CPU_GENERATE=1

RUN \
    go generate ./... \
    && go build \
        -ldflags "-s -w -X github.com/ollama/ollama/version.Version=${VERSION} -X github.com/ollama/ollama/server.mode=release" -o bin/ollama .

FROM ghcr.io/buroa/ubuntu:rolling@sha256:7606a9fe80ba47b2958eed8515d7f755c6b4939f37ab8329813ee6dce3fc1d6c as runner

ENV OLLAMA_HOST 0.0.0.0
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all

RUN \
    mkdir -p /home/kah/.ollama \
    && chown -R kah:kah /home/kah/.ollama

COPY --from=builder --chown=kah:kah /build/bin/ollama /app

USER kah
COPY ./apps/ollama/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/ollama/ollama"
