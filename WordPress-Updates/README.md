# WordPress Updates
As WordPress core adds more and more auto-updating capabilities, these update scripts becomes less necessary, but is a good tool in situations where the filesystem permissions do not allow WordPress to write to code directories (which can be a good security setup).  

<p align="center">
<a href="http://10up.com/contact/"><img src="https://10up.com/uploads/2016/10/10up-Github-Banner.png" width="850"></a>
</p>

## wpupdate.sh
This script is intended to be run via system cron to auto-update a WordPress site (or multiple sites), but could just as easily be run manually when updating WordPress.  It will update core, plugins, and themes, as well as wp-cli, and restart memcached.  While autoupdating is not necessarily recommended on production sites, 10up has used this script to auto-update internal use sites for years with nearly no issues.  
