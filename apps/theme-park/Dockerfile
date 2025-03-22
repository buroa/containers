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
    && grep -rl 'https://theme-park.dev' /tmp | xargs sed -i 's|https\://theme-park.dev||g'

FROM ghcr.io/nginxinc/nginx-unprivileged:1.27-alpine
COPY --from=builder --chown=nginx:nginx /tmp/index.html /usr/share/nginx/html
COPY --from=builder --chown=nginx:nginx /tmp/css /usr/share/nginx/html
COPY --from=builder --chown=nginx:nginx /tmp/resources /usr/share/nginx/html
USER nginx
WORKDIR /usr/share/nginx/html
LABEL org.opencontainers.image.source="https://github.com/themepark-dev/theme.park"
