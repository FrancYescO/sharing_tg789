#!/bin/sh

/etc/init.d/transmission stop
opkg remove transmission-daemon-openssl transmission-remote-openssl ca-bundle libminiupnpc libnatpmp  libevent2 #--force-removal-of-dependent-packages
rm /usr/share/transmission
rm /etc/config/transmission




