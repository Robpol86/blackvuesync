#!/usr/bin/env bash

set -euxo pipefail

# Initialize.
/setuid.sh

# Immediately run on startup.
su -m dashcam /blackvuesync.sh

# Exit if user requested run once.
if [[ -n $RUN_ONCE ]]; then
    exit 1
fi

# Main loop
while true; do
    # Sleep.
    last_file="$(find /recordings/????-??-?? -name "????????_??????_??.mp4" -type f -printf "%f\n" |sort |tail -1 || true)"
    last_file_date="${last_file:0:4}-${last_file:4:2}-${last_file:6:2} ${last_file:9:2}:${last_file:11:2}:${last_file:13:2}"
    last_file_epoch="$(date -d "$last_file_date" +%s)"
    current_epoch="$(date +%s)"
    delta_seconds=$(( current_epoch - last_file_epoch ))
    sleep $(( delta_seconds > SLEEP_CONDITION ? SLEEP_SHORT : SLEEP_LONG ))

    # Wait until camera is reachable.
    until ping -W1 -c1 -q "$ADDRESS"; do sleep 1; done

    # Run.
    su -m dashcam /blackvuesync.sh
done
