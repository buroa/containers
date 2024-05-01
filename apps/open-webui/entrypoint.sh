#!/usr/bin/env bash

PORT="${PORT:-8080}"

if [[ -z "$WEBUI_SECRET_KEY" ]]; then
    echo "WEBUI_SECRET_KEY is not set"

    KEY_FILE=".webui_secret_key"
    if [ ! -e "$KEY_FILE" ]; then
        echo "Generating WEBUI_SECRET_KEY"
        echo $(head -c 12 /dev/random | base64) > $KEY_FILE
    fi

    echo "Loading WEBUI_SECRET_KEY from $KEY_FILE"
    WEBUI_SECRET_KEY=`cat $KEY_FILE`
fi

if [[ -z "$LD_LIBRARY_PATH" ]]; then
    export LD_LIBRARY_PATH="/usr/local/lib/python3.12/site-packages/torch/lib"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/python3.12/site-packages/nvidia/cudnn/lib"
    echo "Setting LD_LIBRARY_PATH to $LD_LIBRARY_PATH"
fi

cd /app/backend

exec \
    uvicorn main:app \
        --host 0.0.0.0 \
        --port "$PORT" \
        --forwarded-allow-ips "*"
