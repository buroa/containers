#!/usr/bin/env bash
channel=$1
version=$(curl -sX GET "https://services.sonarr.tv/v1/download/${channel}?version=4.0" | jq --raw-output '.version' 2>/dev/null)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
