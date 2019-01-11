#!/bin/sh

/etc/init.d/aria2 stop
opkg remove aria2
rm /www/docroot/aria2
sed -i '/--dport 6800:6801 -j/d' /etc/firewall.user
sed -i '/--dport 6801 -j/d' /etc/firewall.user