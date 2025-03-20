#!/usr/bin/env bash

export BEETSDIR="/config/.config/beets"
export BETANINDIR="/config/.config/betanin"

if [[ ! -f "${BEETSDIR}/config.yaml" ]]; then
    mkdir -p "${BEETSDIR}"
    cp /config-beets.yaml "${BEETSDIR}/config.yaml"
fi

if [[ ! -f "${BETANINDIR}/config.toml" ]]; then
    mkdir -p "${BETANINDIR}"
    cp /config-betanin.toml "${BETANINDIR}/config.toml"

    password=$(tr -dc 'a-z0-9' < /dev/urandom | fold -w 32 | head -n 1)
    api_key=$(tr -dc 'a-z0-9' < /dev/urandom | fold -w 32 | head -n 1)
    sed -i -e "s/^password *=.*$/password = \"${password}\"/g" "${BETANINDIR}/config.toml"
    sed -i -e "s/^api_key *=.*$/api_key = \"${api_key}\"/g" "${BETANINDIR}/config.toml"
    echo "Created password and api keys for the user beets:"
    echo "Password: ${password}"
    echo "API Key: ${api_key}"
fi

[[ -n "${BETANIN__PASSWORD}" ]] && sed -i -e "s/^password *=.*$/password = \"${BETANIN__PASSWORD}\"/g" "${BETANINDIR}/config.toml"
[[ -n "${BETANIN__API_KEY}" ]] && sed -i -e "s/^api_key *=.*$/api_key = \"${BETANIN__API_KEY}\"/g" "${BETANINDIR}/config.toml"

exec \
    /usr/local/bin/betanin \
        "$@"
