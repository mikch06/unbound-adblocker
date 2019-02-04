# unbound-adblocker

## For your Opnsense Firewall

The script creates an ad-blocking list for your unbound DNS resolver on your Opnsense Firewall.

run ./unbound-adb-update-hosts.sh

When the script is done:
Goto Services -> Unbound DNS -> General and include your ad-blacklist.conf

    include:/var/unbound/ad-blacklist.conf

After that you can restart/reload unbound and all list entries are resolved by 0.0.0.0 .

- Please add more lists/url's if you like. 
