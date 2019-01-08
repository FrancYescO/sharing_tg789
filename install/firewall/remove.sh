#!/bin/sh

rm /etc/firewall.user.save
cp /mnt/usb/USB-A1/sharing/install/backup/firewall.user /etc/firewall.user
/etc/init.d/firewall restart
