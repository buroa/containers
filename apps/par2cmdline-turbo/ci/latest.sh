#!/usr/bin/env bash
version="$(curl -sX GET "https://api.github.com/repos/animetosho/par2cmdline-turbo/releases/latest" | jq --raw-output '.tag_name' 2>/dev/null)"
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
