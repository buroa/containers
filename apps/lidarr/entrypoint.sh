#!/usr/bin/env bash

 #shellcheck disable=SC2086
 exec \
     /app/bin/Lidarr \
         --nobrowser \
         --data=/config \
         "$@"
