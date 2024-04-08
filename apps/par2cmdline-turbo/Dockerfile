FROM docker.io/library/alpine:3.19 as par2
ARG TARGETARCH
ARG VERSION
ENV LDFLAGS="-static"
USER root
WORKDIR /tmp
RUN \
    apk add --no-cache \
        autoconf \
        automake \
        build-base \
        curl \
        linux-headers \
        musl-dev \
    && \
    curl -fsSL "https://github.com/animetosho/par2cmdline-turbo/archive/refs/tags/v${VERSION}.tar.gz" \
        | tar xzf - -C /tmp --strip-components 1 \
    && ./automake.sh \
    && ./configure \
    && make \
    && make install

FROM docker.io/library/alpine:3.19
COPY --from=par2 /usr/local/bin/par2 /usr/local/bin/par2
RUN /usr/local/bin/par2 --help
CMD ["/usr/local/bin/par2"]
