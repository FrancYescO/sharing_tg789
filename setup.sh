#!/bin/sh

opkg install ./*.ipk
cat <<EOF >> /etc/firewall.user
iptables -I INPUT  -p tcp -m tcp --dport 6800:6801 -j ACCEPT
iptables -I INPUT  -p udp -m udp --dport 6801 -j ACCEPT
EOF
cp ./remove.sh /usr/share/transformer/scripts/remove_aria2.sh
if [ -d /tmp/run/mountd/sda1 ]; then
    mkdir -p /tmp/run/mountd/sda1/sharing/config/aria2
    mkdir -p /tmp/run/mountd/sda1/sharing/download/aria2
    cp -R ./config/* /tmp/run/mountd/sda1/sharing/config/aria2
    cp /tmp/run/mountd/sda1/sharing/config/aria2/aria2 /etc/init.d/aria2
    ln -s /tmp/run/mountd/sda1/sharing/config/aria2/webui /www/docroot/aria
fi