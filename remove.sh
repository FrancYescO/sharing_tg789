#!/bin/sh

rm /usr/share/transmission
rm /www/docroot/transmission
opkg remove transmission-daemon-openssl transmission-remote-openssl ca-bundle libminiupnpc libnatpmp  libevent2 #--force-removal-of-dependent-packages
rm /usr/sbin/transmission-*
rm /etc/init.d/transmission
rm /etc/config/transmission




