ARG VERSION
 FROM docker.io/library/alpine:3.21@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

 ARG TARGETPLATFORM
 ARG VERSION

 ENV \
     COMPlus_EnableDiagnostics="0" \
     LIDARR__UPDATE__BRANCH="develop"

 ENV UMASK="0002" \
     TZ="Etc/UTC"

 USER root
 WORKDIR /app

 #hadolint ignore=DL3018,DL3059
 RUN \
     apk add --no-cache \
         bash \
         ca-certificates \
         catatonit \
         chromaprint \
         coreutils \
         curl \
         ffmpeg \
         icu-libs \
         jo \
         jq \
         libintl \
         nano \
         sqlite-libs \
         trurl \
         tzdata \
     && \
     case "${TARGETPLATFORM}" in \
         'linux/amd64') export ARCH='x64' ;; \
         'linux/arm64') export ARCH='arm64' ;; \
     esac \
     && \
     mkdir -p /app/bin \
     && \
     curl -fsSL "https://lidarr.servarr.com/v1/update/${LIDARR__UPDATE__BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=${ARCH}" \
         | tar xzf - -C /app/bin --strip-components=1 \
     && \
     rm -rf /app/bin/Lidarr.Update /app/bin/fpcalc \
     && \
     printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[szinn](https://github.com/szinn)\n" "${LIDARR__UPDATE__BRANCH}" "${VERSION}" > /app/package_info \
     && chown -R root:root /app \
     && chmod -R 755 /app \
     && rm -rf /tmp/*

 COPY ./entrypoint.sh /entrypoint.sh

 USER nobody:nogroup
 WORKDIR /config
 VOLUME ["/config"]

 ENTRYPOINT ["/usr/bin/catatonit", "--"]
 CMD ["/entrypoint.sh"]

 LABEL org.opencontainers.image.source="https://github.com/Lidarr/Lidarr"
