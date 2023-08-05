#!/usr/bin/env bash

set -euo pipefail

/setuid.sh \
&& su -m dashcam /blackvuesync.sh \
&& [[ -z $RUN_ONCE ]] \
&& crond -f
