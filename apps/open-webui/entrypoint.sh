#!/usr/bin/env bash

if [[ -z "$WEBUI_SECRET_KEY" ]]; then
    echo "WEBUI_SECRET_KEY is not set"

    KEY_FILE=".webui_secret_key"
    if [ ! -e "$KEY_FILE" ]; then
        echo "Generating WEBUI_SECRET_KEY"
        echo $(head -c 12 /dev/random | base64) > $KEY_FILE
    fi

    export WEBUI_SECRET_KEY=`cat $KEY_FILE`
    echo "Loaded WEBUI_SECRET_KEY from $KEY_FILE"
fi

cd /app/backend
exec \
    /usr/local/bin/uvicorn \
        main:app \
        --host 0.0.0.0 \
        --port "${PORT:-8080}" \
        --forwarded-allow-ips "*" \
        "$@"
