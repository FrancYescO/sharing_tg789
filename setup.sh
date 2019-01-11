#!/bin/sh

opkg install ./*.ipk
cp ./amule /etc/init.d/
cat <<EOF >> /etc/firewall.user
iptables -I INPUT  -p tcp --dport 4662 -j ACCEPT
iptables -I INPUT  -p udp --dport 4665 -j ACCEPT
iptables -I INPUT  -p udp --dport 4672 -j ACCEPT
EOF
/etc/init.d/firewall reload
cp ./remove.sh /usr/share/transformer/scripts/remove_amule.sh
#rm -r /usr/share/amule/webserver
if [ -d /mnt/usb/USB-A1 ]; then
    mkdir -p /mnt/usb/USB-A1/sharing/config/amule
    cp -R ./config/* /mnt/usb/USB-A1/sharing/config/amule
    #ln -s /mnt/usb/USB-A1/sharing/config/amule/webserver /usr/share/amule/
fi