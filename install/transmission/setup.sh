#!/bin/sh

opkg install /mnt/usb/USB-A1/sharing/install/transmission/*.ipk
cp /mnt/usb/USB-A1/sharing/install/transmission/transmission-st* /usr/sbin/
cp /mnt/usb/USB-A1/sharing/install/transmission/transmission /etc/init.d/
cp /mnt/usb/USB-A1/sharing/install/transmission/transmission.conf /etc/config/transmission
cd /usr/share/ 
ln -s /mnt/usb/USB-A1/sharing/config/transmission/
cd /www/docroot/
ln -s /mnt/usb/USB-A1/sharing/config/transmission/

