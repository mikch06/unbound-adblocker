# opnsense-unbound-adblock


This script creates a ad blocking list for your unbound DNS resolver and integrates a list of Ad and tracking server lits.
It works with opnsense unbound DNS server.

To make it work clone this repo somewhere on your router.

run update-hosts.sh

when script is done go to router webui -> services -> unbound DNS -> general -> advanced and under Custom options add:

include:/var/unbound/ad-blacklist.conf

After that you can restart/reload unbound and it will block ads.


- Please add more lists if you want. awk line will change any line taht has  something like

This script WAS NOT originally written by me!
I forked this repo from https://github.com/matijazezelj/unbound-adblock.
Special thanks to the initiator of the update-hosts.sh script https://devinstechblog.com/block-ads-with-dns-in-opnsense/
