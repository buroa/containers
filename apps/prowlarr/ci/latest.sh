#!/usr/bin/env bash
channel=$1
version=$(curl -sX GET "https://prowlarr.servarr.com/v1/update/${channel}/changes?os=linux&runtime=netcore" | jq --raw-output '.[0].version' 2>/dev/null)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
