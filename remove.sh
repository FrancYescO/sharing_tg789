#!/bin/sh

opkg remove amule libbfd libupnp libreadline libwxbase libncurses terminfo
rm -r /usr/share/amule/

sed -i '/--dport 4662 -j/d' /etc/firewall.user
sed -i '/--dport 4665 -j/d' /etc/firewall.user
sed -i '/--dport 4672 -j/d' /etc/firewall.user