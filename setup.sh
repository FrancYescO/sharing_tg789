#!/bin/sh

# Post-install setup for dumaos-repack on TCH closed firmware
# (AGTEF / VBNTJ, arm_cortex-a9, kernel 4.1.52).
# The libraries and kernel modules below are provided by the
# GUI_ipk feed: https://github.com/FrancYescO/GUI_ipk

set -e

FEED_DEPS="libedit libncurses terminfo"
# QoS (dpiclass + tc) needs ifb and the packet scheduler modules.
KMOD_DEPS="kmod-ifb kmod-sched-core kmod-sched-connmark"

echo "Installing dependencies from feed..."
opkg update || true
opkg install $FEED_DEPS || \
    echo "WARN: missing feed packages ($FEED_DEPS), sqlite3/ncurses will not work"
opkg install $KMOD_DEPS || \
    echo "WARN: missing kmods ($KMOD_DEPS), DumaOS QoS needs modules matching kernel 4.1.52"

echo "Loading QoS modules..."
for mod in ifb sch_ingress cls_u32 act_police nfnetlink_queue nf_conntrack_netlink ip_set ip_set_hash_ip ip_set_hash_ipport; do
    modprobe "$mod" 2>/dev/null || true
done

echo "Opening DumaOS UI port on the firewall..."
if uci show firewall 2>/dev/null | grep -q "dumaos_ui"; then
    echo "firewall rule dumaos_ui already present, skipping"
else
    cat << EOF >> /etc/config/firewall

config rule 'dumaos_ui'
	option src 'lan'
	option name 'DumaOS UI'
	option proto 'tcp udp'
	option dest_port '81 8443'
	option target 'ACCEPT'
EOF
    uci commit firewall
    /etc/init.d/firewall restart 2>/dev/null || true
fi

# json-c compat: dpiclass/geoip are linked against libjson-c.so.2 (json-c 0.11),
# AGTEF ships libjson-c.so.4 (json-c 0.13).
if [ ! -e /usr/lib/libjson-c.so.2 ] && [ -e /usr/lib/libjson-c.so.4 ]; then
    ln -sn /usr/lib/libjson-c.so.4 /usr/lib/libjson-c.so.2
fi

echo "Starting DumaOS..."
/etc/init.d/uhttpd enable
/etc/init.d/uhttpd start
/etc/init.d/dumaos enable
/etc/init.d/dumaos start

echo "Done. DumaOS UI: http://<router-ip>:81/"
