# opnsense-unbound-adblock

## For you Opnsense Firewall


This script creates an ad blocking list for your unbound DNS resolver on your Opnsense Firewall
and integrates a list of Advert- and tracking server lits.

run ./unbound-adb-update-hosts.sh

when script is done go to router webui -> services -> unbound DNS -> general -> advanced and under Custom options add:

include:/var/unbound/ad-blacklist.conf

After that you can restart/reload unbound and all list entries are resolved by 0.0.0.0 .

- Please add more lists if you want. 

This script WAS NOT originally written by me!
I forked this repo from https://github.com/matijazezelj/unbound-adblock.
Special thanks to the initiator of the update-hosts.sh script https://devinstechblog.com/block-ads-with-dns-in-opnsense/
