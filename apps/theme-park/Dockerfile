FROM ghcr.io/nginxinc/nginx-unprivileged:1.27

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root

#hadolint ignore=DL3008
RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends --no-install-suggests python3 \
    && \
    curl -fsSL "https://github.com/themepark-dev/theme.park/archive/${VERSION}.tar.gz" \
    | tar xzf - -C /tmp --strip-components 1 \
    && \
    python3 /tmp/themes.py \
    && \
    grep -rl 'https://theme-park.dev' /tmp | xargs sed -i 's/https\:\/\/theme-park.dev//g' \
    && \
    cp -r /tmp/css/ /usr/share/nginx/html \
    && cp -r /tmp/resources/ /usr/share/nginx/html \
    && cp /tmp/index.html /usr/share/nginx/html \
    && apt-get remove -y python3 \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && chown -R nginx:nginx /usr/share/nginx/html \
    && chmod -R 755 /usr/share/nginx/html \
    && rm -rf /tmp/*

USER nginx
WORKDIR /usr/share/nginx/html

LABEL org.opencontainers.image.source="https://github.com/themepark-dev/theme.park"
