FROM docker.io/library/python:3.13-alpine AS builder
ARG TARGETPLATFORM
ARG VERSION
#hadolint ignore=DL3008
RUN \
    apk add --no-cache \
        curl \
        grep \
        sed \
        tar \
    && \
    curl -fsSL "https://github.com/themepark-dev/theme.park/archive/${VERSION}.tar.gz" \
        | tar xzf - -C /tmp --strip-components 1 \
    && python /tmp/themes.py \
    && grep -rl 'https://theme-park.dev' /tmp | xargs sed -i 's|https\://theme-park.dev||g' \
    && cp -r /tmp/{css,resources,index.html} /usr/share/nginx/html

FROM ghcr.io/nginxinc/nginx-unprivileged:1.27
COPY --from=builder --chown=nginx:nginx /usr/share/nginx/html /usr/share/nginx/html
USER nginx
WORKDIR /usr/share/nginx/html
LABEL org.opencontainers.image.source="https://github.com/themepark-dev/theme.park"
