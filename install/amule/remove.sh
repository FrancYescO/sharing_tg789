#!/bin/sh

rm /www/docroot//webserver
rm /usr/share/amule/webserver
mkdir /usr/share/amule/webserver
cp -pidRv /mnt/usb/USB-A1/sharing/config/amule/webserver/default /usr/share/amule/webserver/
opkg remove amule libbfd libupnp libreadline libwxbase libncurses terminfo
rm /usr/sbin/amule-*
rm /etc/init.d/amule
rm -r /usr/share/amule/

