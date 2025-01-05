#!/usr/bin/env bash
channel=$1

if [[ "${channel}" == "beta" ]]; then
    git clone --quiet --depth=1 https://aur.archlinux.org/plex-media-server-plexpass.git /tmp/plex-media-server-plexpass
    pushd /tmp/plex-media-server-plexpass > /dev/null || exit
    version="$(grep -oP "(?<=pkgver=).*" PKGBUILD)"
    version="${version}-$(grep -oP "(?<=_pkgsum=).*" PKGBUILD)"
    popd > /dev/null || exit
    rm -rf /tmp/plex-media-server-plexpass
fi

if [[ "${channel}" == "stable" ]]; then
    version=$(curl -sX GET 'https://plex.tv/api/downloads/5.json' | jq -r '.computer.Linux.version')
fi

version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
