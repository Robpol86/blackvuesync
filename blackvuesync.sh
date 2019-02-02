#!/usr/bin/env bash

# keep option set if KEEP set
keep=${KEEP_RANGE:+--keep $KEEP_RANGE}

# disk usage option set if USAGE set
disk_usage=${MAX_USED_DISK:+-u $MAX_USED_DISK}

# timeout set if TIMEOUT set
timeout=${TIMEOUT:+-t $TIMEOUT}

# as many verbose options as the value in VERBOSE
verbose=${VERBOSE:+$(if [[ $VERBOSE -gt 0 ]]; then for i in $(seq 1 $VERBOSE); do echo --verbose; done; fi)}

# dry-run option if DRY_RUN set to anything
quiet="${QUIET:+--quiet}"

# cron option if CRON set to anything
cron="${CRON:+--cron}"

# dry-run option if DRY_RUN set to anything
dry_run="${DRY_RUN:+--dry-run}"


/blackvuesync.py ${ADDRESS} --destination /recordings  ${keep} ${disk_usage} ${timeout} ${verbose} ${quiet} ${cron} ${dry_run}
