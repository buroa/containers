#!/usr/bin/env bash
channel=$1

if [[ "${channel}" == "beta" ]]; then
    version="$(curl -sX GET "https://api.github.com/repos/ollama/ollama/releases" | jq --raw-output 'map(select(.prerelease)) | first | .tag_name' 2>/dev/null)"
else
    version="$(curl -sX GET "https://api.github.com/repos/ollama/ollama/releases/latest" | jq --raw-output '.tag_name' 2>/dev/null)"
fi

if [[ "${version}" == "null" ]]; then
    version="" # fallback to empty string
fi

version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
