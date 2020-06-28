# WP Cron Tools
This is a collection of scripts and tools for managing the WordPress cron (wp-cron) system from the command line.  These scripts require [WP-CLI](https://wp-cli.org/) be installed.

<p align="center">
<a href="http://10up.com/contact/"><img src="https://10up.com/uploads/2016/10/10up-Github-Banner.png" width="850"></a>
</p>

## cronevents.sh
If the WordPress cron stops executing, this can be disasterous for a site. This could happen because of a script that times-out trying to run in cron and keeps getting rescheduled, or a cron job running from the system cron using wp-cli that has failed due to an error.  When this happens, WordPress keeps creating new cron jobs while the old ones never clear.  The "cron" value in the `wp_options` table grows and grows until queries to the `wp_options` table become so slow they are noticeable on page loads.  This can happen very quickly on large sites.  The `cronevents.sh` script can be run in the system cron and will monitor the amount of cron events in the WordPress queue and emails if there are more than a configurable threshold.  Setting the threshold at 100 is a reasonable value to catch broken cron systems before they become a problem with minimal false positives.  

## wpcron-multisite.sh and wpcron-singlesite.sh
For sites that rely on wp-cron, triggering events that are due via a system cron job with WP-CLI may be a better option than letting WordPress trigger the wp-cron events as part of web requests.  Potential reasons you would want to do this:

* Your site doesn't consistent traffic and you want to make sure cron runs regularly, even when there are no web requests
* A multiserver or multicontainer architecture where a single server can be dedicated to doing the wp-cron work. While unlikely to occur, having 1 server run wp-cron rather than all servers in the load balanced pool avoids race conditions
* Very long-running wp-cron jobs can benefit from the different timeouts of PHP from the command line
* More visibility and logging around what cron jobs ran when

The `wpcron-multisite.sh` and `wpcron-singlesite.sh` scripts allow a site administrator to disable wp-cron in wp-config.php with `define('DISABLE_WP_CRON', 'true');` and use wp-cli exclusively to trigger cron events.  These scripts (for multisite and singlesite installs respectively) can be put in `/etc/crontab` and use `flock` to ensure only 1 version is running at a time.
