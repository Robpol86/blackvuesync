#!/usr/bin/env bash

set -euxo pipefail

# Initialize.
/setuid.sh

# Exit if user requested run once.
if [[ -n $RUN_ONCE ]]; then
    su -m dashcam /blackvuesync.sh
    exit 1
fi

# Main loop
while true; do
    # Wait until camera is reachable.
    until ping -W1 -c1 -q "$ADDRESS"; do sleep 1; done

    # Get most recent filename on camera.
    awk_program='/Record.[0-9]{8}_[0-9]{6}_.F.mp4/{m=$3} END {print m}'
    last_file_remote="$(curl -sq "http://$ADDRESS/blackvue_vod.cgi" |grep Record |sort |awk -F'[/,]' "$awk_program" || true)"
    last_file_local="/recordings/${last_file_remote:0:4}-${last_file_remote:4:2}-${last_file_remote:6:2}/$last_file_remote"

    # Sleep.
    if [ -n "$last_file_remote" ] && [ -s "$last_file_local" ]; then
        # Latest remote file exists locally. Sleep long. Caveat: does not take into account rear/interior/etc cameras.
        sleep "$SLEEP_LONG"
    else
        sleep "$SLEEP_SHORT"
    fi

    # Run.
    su -m dashcam /blackvuesync.sh
done
