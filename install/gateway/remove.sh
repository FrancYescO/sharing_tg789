#!/bin/sh

rm /www/gateway-snippets/header.lp.save
rm /www/gateway-snippets/header.lp.new
cp /mnt/usb/USB-A1/sharing/install/backup/header.lp /www/gateway-snippets/header.lp
cp /mnt/usb/USB-A1/sharing/install/backup/nginx.conf /etc/nginx/
/etc/init.d/nginx restart

