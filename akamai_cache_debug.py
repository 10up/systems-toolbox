#!/usr/bin/env python

# akamai_cache_debug.py
# uses Pragma headers to debug full page caching on akamai_cache_debug
# https://community.akamai.com/community/web-performance/blog/2015/03/31/using-akamai-pragma-headers-to-investigate-or-troubleshoot-akamai-content-delivery
#
# add your list of domains to the sites variable and run the script
import requests

agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36"

sites = [
    'example1.com',
    'example2.com'
]

headers = {
    'User-Agent': '{}'.format(agent),
    'Pragma': 'akamai-x-check-cacheable',
    #'Pragma': 'akamai-x-cache-on',
    #'Pragma': 'akamai-x-cache-remote-on'

}

for site in sites:
    print(site)
    resp = requests.get("http://{}".format(site), headers=headers)
    print("Status Code: {}".format(resp.status_code))
    if resp.status_code == 200:
        if "X-Check-Cacheable" in resp.headers:
            print("Cacheable: {}".format(resp.headers['X-Check-Cacheable']))
        if "Vary" in resp.headers:
            print("Vary: {}".format(resp.headers['Vary']))
        if "X-Cache" in resp.headers:
            print("X-Cache: {}".format(resp.headers['X-Cache']))
        if "X-Cache-Remote" in resp.headers:
            print("X-Cache-Remote: {}".format(resp.headers['X-Cache-Remote']))
    elif resp.status_code == 301:
        print("Redirected to: {}".format(resp.headers['Location']))
    print()
