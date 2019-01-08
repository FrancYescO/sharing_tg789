#!/bin/sh

opkg install ./*.ipk
cp ./transmission-st* /usr/sbin/
cp ./transmission /etc/init.d/
cp ./transmission.conf /etc/config/transmission
#cat <<EOF >> /etc/firewall.user
#iptables -I INPUT  -p tcp -m tcp --dport 6800:6801 -j ACCEPT
#iptables -I INPUT  -p udp -m udp --dport 6801 -j ACCEPT
#EOF
cp ./remove.sh /usr/share/transformer/scripts/remove_transmission.sh
if [ -d /mnt/usb/USB-A1 ]; then
    mkdir -p /mnt/usb/USB-A1/sharing/config/transmission/
    cp -R ./config/* /mnt/usb/USB-A1/sharing/config/transmission/
    ln -s /mnt/usb/USB-A1/sharing/config/transmission/ /usr/share/transmission
    ln -s /mnt/usb/USB-A1/sharing/config/transmission/ /www/docroot/transmission
fi