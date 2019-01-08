#!/bin/sh

cd /www/docroot/
ln -s /mnt/usb/USB-A1/sharing/config/amule/webserver
ln -s /mnt/usb/USB-A1/sharing/config/aria2/webui aria2
ln -s /mnt/usb/USB-A1/sharing/config/transmission/
sh /mnt/usb/USB-A1/sharing/install/gateway/setup.sh
sh /mnt/usb/USB-A1/sharing/install/gateway/configure.sh
