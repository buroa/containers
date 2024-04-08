FROM docker.io/library/golang:1.22.2-bookworm as golang

FROM docker.io/nvidia/cuda:12.4.0-devel-ubuntu22.04 as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /build

RUN \
    apt-get -qq update \
    && \
    apt-get -qq install --no-install-recommends --no-install-suggests -y \
        ccache \
        cmake \
        git \
    && \
    git clone --depth 1 --branch v${VERSION} https://github.com/ollama/ollama.git .

COPY --from=golang /usr/local/go/ /usr/local/go/

ENV CMAKE_DEFS="-DLLAMA_CUDA_FORCE_MMQ=off" \
    PATH="/usr/local/go/bin:${PATH}" \
    OLLAMA_SKIP_CPU_GENERATE=1

RUN go generate ./... \
    && go build \
        -ldflags \
            "-s -w \
            -X github.com/ollama/ollama/version.Version=${VERSION} \
            -X github.com/ollama/ollama/server.mode=release" \
    -o bin/ollama .

FROM docker.io/library/ubuntu:24.04

USER root

RUN \
    apt-get -qq update \
    && \
    apt-get -qq install --no-install-recommends --no-install-suggests -y \
        bash \
        ca-certificates \
        catatonit \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/

ENV OLLAMA_HOST="0.0.0.0"

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    LD_LIBRARY_PATH="/usr/local/nvidia/lib:/usr/local/nvidia/lib64" \
    NVIDIA_DRIVER_CAPABILITIES="compute,utility" \
    NVIDIA_VISIBLE_DEVICES="all"

WORKDIR /root/.ollama
COPY --from=builder /build/bin/ollama /usr/local/bin/ollama
COPY ./apps/ollama/entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/usr/bin/catatonit", "--" ]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/ollama/ollama"
