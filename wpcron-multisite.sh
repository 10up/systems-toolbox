#!/usr/bin/env bash

# wpcron-multisite.sh
#
# bash script to execute pending cron events for all sites on a WordPress multisite install
# set: `define('DISABLE_WP_CRON', true);` in wp-config.php to prevent cron from spawning
# on page loads, and configure this script to run out of the system cron. It is recommended
# to use a lock file to prevent multiple instances of this script running at the same time
#
# */5 * * * * flock -xn /tmp/wp-cli-cron.lck -c /opt/scripts/wpcron-multisite.sh >> /var/log/wpcron.log
#
# the script will output overall timing for wp-cron execution, as well as for each individual
# site on the multisite and for each wp-cron event, so capturing this output to a log file
# is highly recommended
# set $AS_ROOT variable to 1 if running this script as the root user

WP_PATH="/path/to/wordpress/"
# path to wp-cli binary
WPCLI="/usr/local/bin/wp"
AS_ROOT=0
FLAGS=""

if [ $AS_ROOT -eq 1 ]; then FLAGS="--allow-root"; fi

echo "executing wp-cron at $(date)"
START=$(date +%s.%N)
for site in $($WPCLI $FLAGS --allow-root --path=$WP_PATH site list --field=url)
do
    echo "running cron for $site"
    SITESTART=$(date +%s.%N)
    $WPCLI $FLAGS --path=$WP_PATH cron event run --due-now --url=$site
    SITEEND=$(date +%s.%N)
    DIFF=$(echo $SITEEND - $SITESTART | bc)
    echo "total run time for $site $DIFF"
    echo
done
END=$(date +%s.%N)
DIFF=$(echo $END - $START | bc)
echo
echo "total wp-cron run time $DIFF"
echo
