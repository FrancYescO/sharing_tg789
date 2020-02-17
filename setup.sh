#!/bin/sh

if [ -d /tmp/run/mountd/sda1 ]; then
   echo "OK USB Found"
   else  
       if [ -d /mnt/usb/* ] ; then
          echo "Link to usb"
          sda1=$(ls /mnt/usb/)
          mkdir -p /tmp/run/mountd/
          ln -s /mnt/usb/$sda1 /tmp/run/mountd/sda1
          else
              exit 1
       fi
fi
opkg update
opkg install aria2 # opkg install ./*.ipk
cat <<EOF >> /etc/firewall.user
iptables -I INPUT  -p tcp -m tcp --dport 6800:6801 -j ACCEPT
iptables -I INPUT  -p udp -m udp --dport 6801 -j ACCEPT
EOF
/etc/init.d/firewall restart
cp ./remove.sh /usr/share/transformer/scripts/remove_aria2.sh
mkdir -p /tmp/run/mountd/sda1/sharing/config/aria2
mkdir -p /tmp/run/mountd/sda1/sharing/download/aria2
cp -R ./config/* /tmp/run/mountd/sda1/sharing/config/aria2
cp /tmp/run/mountd/sda1/sharing/config/aria2/aria2 /etc/init.d/aria2
ln -s /tmp/run/mountd/sda1/sharing/config/aria2/webui /www/docroot/aria


