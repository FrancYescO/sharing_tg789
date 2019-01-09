#!/bin/sh

opkg install /mnt/usb/USB-A1/sharing/install/amule/*.ipk
cp /mnt/usb/USB-A1/sharing/install/amule/amule-* /usr/sbin/
cp /mnt/usb/USB-A1/sharing/install/amule/amule /etc/init.d/
rm -r /usr/share/amule/webserver
cd /usr/share/amule/
ln -s /mnt/usb/USB-A1/sharing/config/amule/webserver
cd /www/docroot/
ln -s /mnt/usb/USB-A1/sharing/config/amule/webserver

# aMule
iptables -I INPUT  -p tcp --dport 4662 -j ACCEPT
iptables -I INPUT  -p udp --dport 4665 -j ACCEPT
iptables -I INPUT  -p udp --dport 4672 -j ACCEPT


#!/bin/sh

opkg install ./*.ipk
cp ./amule-* /usr/sbin/
cp ./amule /etc/init.d/
cat <<EOF >> /etc/firewall.user
iptables -I INPUT  -p tcp --dport 4662 -j ACCEPT
iptables -I INPUT  -p udp --dport 4665 -j ACCEPT
iptables -I INPUT  -p udp --dport 4672 -j ACCEPT
EOF
cp ./remove.sh /usr/share/transformer/scripts/remove_amule.sh
rm -r /usr/share/amule/webserver
if [ -d /mnt/usb/USB-A1 ]; then
    mkdir -p /mnt/usb/USB-A1/sharing/config/amule
    cp -R ./config/* /mnt/usb/USB-A1/sharing/config/amule
    cd /usr/share/amule/
    ln -s /mnt/usb/USB-A1/sharing/config/amule/webserver
    cd /www/docroot/
    ln -s /mnt/usb/USB-A1/sharing/config/amule/webserver
fi