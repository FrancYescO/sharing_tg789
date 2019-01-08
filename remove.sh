#!/bin/sh

opkg remove aria2 
rm /usr/sbin/aria2-*
rm /www/docroot/aria2
sed -i '/--dport 6800:6801 -j/d' /etc/firewall.user
sed -i '/--dport 6801 -j/d' /etc/firewall.user