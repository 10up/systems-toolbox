#!/usr/bin/env bash
#
# wpcron-multisite.sh
# bash script to execute pending cron events for all sites on a WordPress multisite install
# set: `define('DISABLE_WP_CRON', true);` in wp-config.php to prevent cron from spawning
# on page loads, and configure this script to run out of the system cron.
# The script will output overall timing for wp-cron execution, as well as for each individual
# site on the multisite and for each wp-cron event, so capturing this output to a log file
# is highly recommended
# set $AS_ROOT variable to 1 if running this script as the root user

WP_PATH="/path/to/wordpress"
LOCK_FILE="/tmp/wp-cron.lock"
# path to wp-cli binary
WPCLI="/path/to/wp-cli"

cleanup() {
    # remove file lock if the script dies
    rm -f "$LOCK_FILE"
}

if [ -e $LOCK_FILE ] ; then
    exit 1
fi

# adding the trap specifically after checking for existnece of the lock file above
# otherwise second script run will find the lock file, exit and then remove
# the lock file, allowing another instance to run even if the first isn't done
trap cleanup EXIT

touch $LOCK_FILE

if [[ $EUID -eq 0 ]]; then WPCLI="$WPCLI --allow-root"; fi

echo "executing wp-cron at $(date)"
START=$(date +%s.%N)
SITESTART=$(date +%s.%N)
$WPCLI --path=$WP_PATH cron event run --due-now --url=$site
DIFF=$(echo $SITEEND - $SITESTART | bc)
echo
END=$(date +%s.%N)
DIFF=$(echo $END - $START | bc)
echo
echo "total wp-cron run time $DIFF"
echo

rm -f $LOCK_FILE
