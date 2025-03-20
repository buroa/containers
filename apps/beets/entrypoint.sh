#!/usr/bin/env bash

export BEETSDIR="/config/.config/beets"
export FPCALC="/usr/bin/fpcalc"
export BETANINDIR="/config/.cache/betanin"

if [[ ! -d "${BEETSDIR}" ]]; then
    mkdir -p "${BEETSDIR}"
fi

if [[ ! -f "${BEETSDIR}/config.yaml" ]]; then
    cp /config-beets.yaml "${BEETSDIR}/config.yaml"
fi

if [[ ! -d "${BETANINDIR}" ]]; then
    mkdir -p "${BETANINDIR}"
fi

if [[ ! -f "${BETANINDIR}/config.toml" ]]; then
    envsubst < /config-betanin.toml.tpl > "${BETANINDIR}/config.toml"
fi

exec \
    /usr/bin/betanin \
        "$@"
