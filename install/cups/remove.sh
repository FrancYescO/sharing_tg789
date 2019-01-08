#!/bin/sh 
rm /etc/init.d/cupsd/cupsd.save 
cp /mnt/usb/USB-A1/sharing/install/backup/cupsd /etc/init.d/cupsd
cupsctl WebInterface=no

