#!/bin/sh

if [ -d /tmp/run/mountd/sda1 ]; then
    mkdir /usr/share/amule
    mkdir -p /tmp/run/mountd/sda1/sharing/config/amule/webserver
    mkdir -p /tmp/run/mountd/sda1/sharing/download/amule/files
    mkdir -p /tmp/run/mountd/sda1/sharing/download/amule/temp
    cp -R ./config/* /tmp/run/mountd/sda1/sharing/config/amule
    ln -s /tmp/run/mountd/sda1/sharing/config/amule/webserver /usr/share/amule/
    opkg install ./*.ipk
    cp ./amule /etc/init.d/
    cat <<EOF >> /etc/firewall.user
iptables -I INPUT  -p tcp --dport 4662 -j ACCEPT
iptables -I INPUT  -p udp --dport 4665 -j ACCEPT
iptables -I INPUT  -p udp --dport 4672 -j ACCEPT
EOF
    /etc/init.d/firewall reload
    cp ./remove.sh /usr/share/transformer/scripts/remove_amule.sh
    mkdir -p /tmp/run/mountd/sda1/sharing/config/amule
fi