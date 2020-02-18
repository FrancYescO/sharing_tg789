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

opkg  update
opkg install transmission-daemon-openssl transmission-remote-openssl ca-bundle libminiupnpc libnatpmp  libevent2 #./*.ipk
cp ./transmission.conf /etc/config/transmission
cp ./remove.sh /usr/share/transformer/scripts/remove_transmission.sh
if [ -d /tmp/run/mountd/sda1 ]; then
    mkdir -p /tmp/run/mountd/sda1/sharing/config/transmission/
    mkdir -p /tmp/run/mountd/sda1/sharing/download/transmission
    cp -R ./config/* /tmp/run/mountd/sda1/sharing/config/transmission/
    cp  /tmp/run/mountd/sda1/sharing/config/transmission/transmission /etc/init.d/transmission
    mkdir -p /tmp/run/mountd/sda1/sharing/config/transmission/config/torrents
    mkdir -p /tmp/run/mountd/sda1/sharing/config/transmission/config/resume
    mkdir -p /tmp/run/mountd/sda1/sharing/config/transmission/config/blocklists
    ln -s /tmp/run/mountd/sda1/sharing/config/transmission/ /usr/share/transmission
fi
