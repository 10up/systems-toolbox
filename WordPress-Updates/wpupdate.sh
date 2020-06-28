#!/usr/bin/env bash

####
# Update WordPress core, plugins, and themes using wp-cli.  Also update wp-cli.
# Recommended to run this nightly via system cron to auto-update everything. 
# 
# Author: 10up
####


#update wp-cli first
wp cli update --allow-root --yes

# If you have more than 1 WordPress site to update, this is 1 directory up from the directory 
# where the sites are. 
basedir='/var/www/'

# List of directory names under the $basedir that contain the WordPress sites
wpsites=('site1.com' 'site2.com' 'other-site-directory')

# Loop through sites, do updates via wp-cli
for site in ${wpsites[*]}
do
    cd ${basedir}${site}
    wp core update --allow-root
    checkmulti=$(grep MULTISITE wp-config.php)
    if [[ -n $checkmulti ]]; then
        wp --allow-root core update-db --network
    else
        wp --allow-root core update-db
    fi
    wp plugin update --allow-root --all
    wp theme update --allow-root --all
    wp cache flush --allow-root
done

# If memcached is installed (and using a systemd OS), restart memcached to clear the cache. 
systemctl restart memcached
