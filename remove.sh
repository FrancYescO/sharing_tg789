#!/bin/sh

opkg remove aria2 
rm /usr/sbin/aria2-*
rm /www/docroot/aria2
sed -e '/#aria2/,+2d' /etc/firewall.user