# unbound-adblocker

## For your Opnsense Firewall

This script creates an ad blocking list for your unbound DNS resolver on your Opnsense Firewall<br>
and integrates a list of Advert- and tracking server lits.

run ./unbound-adb-update-hosts.sh

when script is done go to router webui -> services -> unbound DNS -> general -> advanced<br>
Under Custom options add:

include:/var/unbound/ad-blacklist.conf

After that you can restart/reload unbound and all list entries are resolved by 0.0.0.0 .

- Please add more lists/url's if you like. 
