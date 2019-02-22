#!/bin/sh
# This script downloads preconfigured ads- and blacklists
# and bring them in a unbound resolver reading format. 
# unbound entries will be sorted and uniqe in the ad-blacklist.conf
# file in your /var/unbound folder.

# Clean up any stale tempfile
echo "Removing old tmp files..."
[ -f /tmp/hosts.tmp ] && rm -f /tmp/hosts.tmp

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
# Fetch all Blacklist Files
echo "Fetching Blacklists..."
for url in $blacklist; do
    curl --silent $url >> "/tmp/hosts-download.tmp"
    echo $url done
done

# Count entries in old blacklist
echo "Count entries in old list"
oldlines=$(cat /var/unbound/ad-blacklist.conf|wc -l)

# Backup ad-blacklist.conf
echo "Backup old list: ad-blacklist.conf -> ad-blacklist.conf.bak"
cp /var/unbound/ad-blacklist.conf /var/unbound/ad-blacklist.conf.bak

# Process Blacklists, filter IP and alphabetical entries.
echo "Processing Blacklist..."
cat /tmp/hosts-download.tmp|grep '^127.0\|^0.0.0.0'|awk '{print $2}' > /tmp/hosts-raw.tmp
cat /tmp/hosts-download.tmp|grep '^[a-z]'|awk '{print $1}' >> /tmp/hosts-raw.tmp

# Combine ad-blacklist, remove duplicates, converting to unbound format
echo "Combine ad-blacklist..."
cat /tmp/hosts-raw.tmp|awk '{gsub("\r","")};{print "local-data: " "\"" $0" A 0.0.0.0\""}'|sort|uniq > /var/unbound/ad-blacklist.conf

# Count entries in new blacklist
newlines=$(cat /var/unbound/ad-blacklist.conf|wc -l)

# Clean up tempfile
echo "Cleaning Up..."
rm -f '/tmp/hosts.tmp'
echo

# Count entries in new blacklist
newlines=$(cat /var/unbound/ad-blacklist.conf|wc -l)

# Diff entries
echo "Blacklist entries before:"
echo $oldlines
echo "Blacklist entries now:"
echo $newlines

echo "Done."
echo "Please Restart the DNS Resolver service from the WebUI."
