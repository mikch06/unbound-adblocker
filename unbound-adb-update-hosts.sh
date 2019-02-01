#!/bin/sh

## Count entries in old blacklist
oldlines=$(cat /var/unbound/ad-blacklist.conf|wc -l)

## Clean up any stale tempfile
echo "Removing old files..."
[ -f /tmp/hosts.tmp ] && rm -f /tmp/hosts.tmp

## Awk regex to be inverse-matched as whitelist
# SolveMedia is needed for captchas on some websites
whitelist='/(api.solvemedia.com)/'

# All Blacklists
blacklist='
http://winhelp2002.mvps.org/hosts.txt
http://pgl.yoyo.org/as/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext
https://adaway.org/hosts.txt
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://mirror1.malwaredomains.com/files/justdomains
http://sysctl.org/cameleon/hosts https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist
https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
https://hosts-file.net/ad_servers.txt
'

## Fetch all Blacklist Files
echo "Fetching Blacklists..."
for url in $blacklist; do
    curl --silent $url >> "/tmp/hosts.tmp"
    echo $url done
done

## Process Blacklist, Eliminiating Duplicates, Integrating Whitelist, and Converting to unbound format
echo "Processing Blacklist..."
awk -v whitelist="$whitelist" '$1 ~ /^127\.|^0\./ && $2 !~ whitelist {gsub("\r",""); print tolower($2)}' /tmp/hosts.tmp | sort | uniq | \
awk '{printf "server:\n", $1; printf "local-data: \"%s A 0.0.0.0\"\n", $1}' > /var/unbound/ad-blacklist.conf

## Count entries in new blacklist
newlines=$(cat /var/unbound/ad-blacklist.conf|wc -l)

## Clean up tempfile
echo "Cleaning Up..."
rm -f '/tmp/hosts.tmp'
echo
echo "Done. Please Restart the DNS Resolver service from the WebUI."
echo

## Count entries in new blacklist
newlines=$(cat /var/unbound/ad-blacklist.conf|wc -l)

## Diff entries
echo "Blacklist entries before:"
echo $oldlines
echo "Blacklist entries now:"
echo $newlines
