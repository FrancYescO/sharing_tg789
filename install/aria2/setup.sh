#!/bin/sh

opkg install /mnt/usb/USB-A1/sharing/install/aria2/*.ipk
cp /mnt/usb/USB-A1/sharing/install/aria2/aria2-* /usr/sbin/
cp /mnt/usb/USB-A1/sharing/install/aria2/aria2 /etc/init.d/
cd /www/docroot 
ln -s /mnt/usb/USB-A1/sharing/config/aria2/webui aria2

