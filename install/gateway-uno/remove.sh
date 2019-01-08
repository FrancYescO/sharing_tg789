#!/bin/sh

rm /www/docroot/gateway.lp.save
rm /www/docroot/gateway.lp.new
cp /mnt/usb/USB-A1/sharing/install/backup/gateway.lp /www/docroot/gateway.lp
cp /mnt/usb/USB-A1/sharing/install/backup/nginx.conf /etc/nginx/
/etc/init.d/nginx restart

