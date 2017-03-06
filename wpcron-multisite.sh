#!/usr/bin/env bash
echo "executing wp-cron at $(date)"

WP_PATH="/var/www/sites/templates/phillymag/wordpress/"

START=$(date +%s.%N)
for site in $(/usr/local/bin/wp --allow-root --path=$WP_PATH site list --field=url)
do
    echo "running cron for $site"
    SITESTART=$(date +%s.%N)
    sudo -u nginx /usr/local/bin/wp --path=$WP_PATH cron event run --due-now --url=$site
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
