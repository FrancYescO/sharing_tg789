#!/bin/sh

opkg install ./*.ipk
cp ./aria2-* /usr/sbin/
cp ./aria2 /etc/init.d/
cat <<EOF >> /etc/firewall.user
iptables -I INPUT  -p tcp -m tcp --dport 6800:6801 -j ACCEPT
iptables -I INPUT  -p udp -m udp --dport 6801 -j ACCEPT
EOF
cp ./remove.sh /usr/share/transformer/scripts/remove_aria2.sh
if [ -d /mnt/usb/USB-A1 ]; then
    mkdir -p /mnt/usb/USB-A1/sharing/config/aria2
    cp -R ./config/* /mnt/usb/USB-A1/sharing/config/aria2
    ln -s /mnt/usb/USB-A1/sharing/config/aria2/webui /www/docroot/aria2
fi