#!/usr/bin/env bash

set -euo pipefail

if [[ $PUID -gt 0 ]]; then
    usermod -o -u "$PUID" dashcam
fi

if [[ $PGID -gt 0 ]]; then
    groupmod -o -g "$PGID" dashcam
fi
