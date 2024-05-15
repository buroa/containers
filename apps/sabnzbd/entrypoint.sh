#!/usr/bin/env bash

if [[ ! -f "/config/sabnzbd.ini" ]]; then
    printf "Copying over default configuration ...\n"
    mkdir -p /config/sabnzbd
    cp /app/sabnzbd.ini /config/sabnzbd.ini

    printf "Creating api keys ...\n"
    api_key=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1)
    nzb_key=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1)
    sed -i -e "s/^api_key *=.*$/api_key = ${api_key}/g" /config/sabnzbd.ini
    sed -i -e "s/^nzb_key *=.*$/nzb_key = ${nzb_key}/g" /config/sabnzbd.ini
fi

[[ -n "${SABNZBD__API_KEY}" ]] && sed -i -e "s/^api_key *=.*$/api_key = ${SABNZBD__API_KEY}/g" /config/sabnzbd.ini
[[ -n "${SABNZBD__NZB_KEY}" ]] && sed -i -e "s/^nzb_key *=.*$/nzb_key = ${SABNZBD__NZB_KEY}/g" /config/sabnzbd.ini
[[ -n "${SABNZBD__HOST_WHITELIST_ENTRIES}" ]] && sed -i -e "s/^host_whitelist *=.*$/host_whitelist = ${HOSTNAME:-sabnzbd}, ${SABNZBD__HOST_WHITELIST_ENTRIES}/g" /config/sabnzbd.ini

#shellcheck disable=SC2086
exec \
    /usr/local/bin/python \
        /app/SABnzbd.py \
        --browser 0 \
        --server 0.0.0.0:${SABNZBD__PORT:-8080} \
        --config-file /config/sabnzbd.ini \
        "$@"
