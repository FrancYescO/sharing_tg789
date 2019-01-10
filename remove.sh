#!/bin/sh

rm /usr/share/transmission
opkg remove transmission-daemon-openssl transmission-remote-openssl ca-bundle libminiupnpc libnatpmp  libevent2 #--force-removal-of-dependent-packages
rm /etc/config/transmission




