#!/usr/bin/env bash
channel=$1

if [[ "${channel}" == "stable" ]]; then
    version=$(curl -sL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -r '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"' 2>/dev/null)
    version="${version#*release-}"
    version="${version%%_*}"
    printf "%s" "${version}"
fi

if [[ "${channel}" == "beta" ]]; then
    version=$(curl -sL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -r '. | "release-\(.qbittorrent)_v\(.libtorrent_2_0)"' 2>/dev/null)
    version="${version#*release-}"
    version="${version%%_*}"
    printf "%s" "${version}"
fi
