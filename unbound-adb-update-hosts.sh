#!/bin/sh
# This script downloads preconfigured ads- and blacklists
# and bring them in a unbound resolver reading format. 
# unbound entries will be sorted and uniqe in the ad-blacklist.conf
# file in your /var/unbound folder.

## Count entries in old blacklist
oldlines=$(cat /var/unbound/ad-blacklist.conf|wc -l)

## Backup ad-blacklist.conf
cp /var/unbound/ad-blacklist.conf /var/unbound/ad-blacklist.conf.bak

## Clean up any stale tempfile
##echo "Removing old files..."
##[ -f /tmp/hosts.tmp ] && rm -f /tmp/hosts.tmp

# Ads- and Blacklists
blacklist='
http://winhelp2002.mvps.org/hosts.txt
http://pgl.yoyo.org/as/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext
https://adaway.org/hosts.txt
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://mirror1.malwaredomains.com/files/justdomains
http://sysctl.org/cameleon/hosts 
https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist
https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
https://hosts-file.net/ad_servers.txt
'
## Fetch all Blacklist Files
echo "Fetching Blacklists..."
for url in $blacklist; do
    curl --silent $url >> "/tmp/hosts-download.tmp"
    echo $url done
done

# Process Blacklists, filter IP and alphabetical entries.
echo "Processing Blacklist..."
##time cat /tmp/hosts.tmp|grep '^127.0\|^0.0\|awk {gsub("\r","")};{print $2}'|sort|uniq -ui| \
##awk '{printf "local-data: \"%s A 0.0.0.0\"\n", $1}' > /var/unbound/ad-blacklist.conf

cat /tmp/hosts-download.tmp|grep '^127.0\|^0.0.0.0'|awk '{print $2}' > hosts-raw.tmp
cat /tmp/hosts-download.tmp|grep '^[a-z]'|awk '{print $1}' >> hosts-raw.tmp

# Combine ad-blacklist, remove duplicates, converting to unbound format
echo "Combine ad-blacklist"
cat /tmp/hosts-raw.tmp|sort|uniq|awk '{printf "local-data: \"%sA 0.0.0.0\"\n", $1}' > /tmp/ad-blacklist.conf

## Count entries in new blacklist
newlines=$(cat /var/unbound/ad-blacklist.conf|wc -l)

## Clean up tempfile
echo "Cleaning Up..."
##rm -f '/tmp/hosts.tmp'
echo

## Count entries in new blacklist
newlines=$(cat /var/unbound/ad-blacklist.conf|wc -l)

## Diff entries
echo "Blacklist entries before:"
echo $oldlines
echo "Blacklist entries now:"
echo $newlines

echo "Done."
echo "Please Restart the DNS Resolver service from the WebUI."
