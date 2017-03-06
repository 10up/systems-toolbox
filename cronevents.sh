#!/usr/bin/env bash

# cronevents.sh
# monitor the number of cron events for each site on a WordPress multisite and send
# an email alert if it is above an alarming number
# requires jq and uses the default system mailer to send alerts

WP_PATH="/path/to/wordpress/"
# path to wp-cli binary
WPCLI="/usr/local/bin/wp"
AS_ROOT=0
FLAGS=""

alert='alertemail@domain.com'
# alert when cron events go above
max_events=100

if [ $AS_ROOT -eq 1 ]; then FLAGS="--allow-root"; fi

cd $WP_PATH
for site in $($WPCLI $FLAGS --allow-root site list --field=url)
do

  events=$($WPCLI $FLAGS --url=$site option get cron --format=json)
  num_events=$(echo $events | jq '. | length')
  if [ $num_events -gt $max_events ]
  then
    mail -s "WARNING cron events for $site" $alert <<< "check the cron events on $site, there are currently $num_events cron events scheduled which is larger than $max_events

$(echo $events | jq .)"
  fi

  # for bonus points send this cron option size to statsd
  # and make a nice graphana graph
  #echo "cronevents.$site:$num_events|g" | nc -u -w1 127.0.0.1 8125

done
