#!/usr/bin/env bash
#shellcheck disable=SC2086

unset UV_SYSTEM_PYTHON
mkdir -p "${VENV_FOLDER}"
uv venv --system-site-packages --link-mode=copy --allow-existing "${VENV_FOLDER}"
source "${VENV_FOLDER}/bin/activate"
uv pip freeze --system | grep ^uv= | xargs uv pip install

ln -sf /proc/self/fd/1 /config/home-assistant.log

exec \
    python3 -m homeassistant \
        --config /config \
        "$@"
