#!/bin/sh

opkg install ./*.ipk
cp ./transmission.conf /etc/config/transmission
cp ./remove.sh /usr/share/transformer/scripts/remove_transmission.sh
if [ -d /tmp/run/mountd/sda1 ]; then
    mkdir -p /tmp/run/mountd/sda1/sharing/config/transmission/
    mkdir -p /tmp/run/mountd/sda1/sharing/download/transmission
    cp -R ./config/* /tmp/run/mountd/sda1/sharing/config/transmission/
    mkdir -p /tmp/run/mountd/sda1/sharing/config/transmission/torrents
    mkdir -p /tmp/run/mountd/sda1/sharing/config/transmission/resume
    mkdir -p /tmp/run/mountd/sda1/sharing/config/transmission/blocklists
    ln -s /tmp/run/mountd/sda1/sharing/config/transmission/ /usr/share/transmission
fi