#!/bin/sh

opkg install ./*.ipk
cp ./aria2-* /usr/sbin/
cp ./aria2 /etc/init.d/
if [ -d /mnt/usb/USB-A1 ]; then
    mkdir -p /mnt/usb/USB-A1/sharing/config/aria2
    cp -R ./config/* /mnt/usb/USB-A1/sharing/config/aria2
    ln -s /mnt/usb/USB-A1/sharing/config/aria2/webui /www/docroot/aria2
fi