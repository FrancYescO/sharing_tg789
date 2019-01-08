#!/bin/sh

opkg install /mnt/usb/USB-A1/sharing/install/amule/*.ipk
cp /mnt/usb/USB-A1/sharing/install/amule/amule-* /usr/sbin/
cp /mnt/usb/USB-A1/sharing/install/amule/amule /etc/init.d/
rm -r /usr/share/amule/webserver
cd /usr/share/amule/
ln -s /mnt/usb/USB-A1/sharing/config/amule/webserver
cd /www/docroot/
ln -s /mnt/usb/USB-A1/sharing/config/amule/webserver

