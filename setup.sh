#!/bin/sh

# Post-install setup for dumaos-repack on TCH closed firmware
# (AGTEF / VBNTJ, arm_cortex-a9, kernel 4.1.52).
# The libraries and kernel modules below are provided by the
# GUI_ipk feed: https://github.com/FrancYescO/GUI_ipk

set -e

FEED_DEPS="libedit libncurses terminfo"

echo "Installing dependencies from feed..."
opkg update || true
opkg install $FEED_DEPS || \
    echo "WARN: missing feed packages ($FEED_DEPS), sqlite3/ncurses will not work"

# QoS: AGTEF (Damson VBNTJ 4.1.52) has ifb/sch_ingress/cls_u32/act_police
# built into the kernel (see /etc/modules.d/34-ifb and 70-sched-core);
# act_connmark is the only missing module and is provided by the GUI_ipk
# kmods-4.1.52 branch (vermagic "4.1.52 SMP preempt mod_unload ARMv7").
ACT_CONNMARK_NAME="act-connmark-damson-4.1.52.ko"
ACT_CONNMARK_SHA="9bbd94d4e1ed2d02e1c990797b6540d3af3a4a13680099cb7014c4e211bc83ff"
ACT_CONNMARK_URL="https://raw.githubusercontent.com/FrancYescO/GUI_ipk/kmods-4.1.52/artifacts/$ACT_CONNMARK_NAME"

kver=$(uname -r)
if [ "$kver" = "4.1.52" ]; then
    if ! lsmod | grep -q "^act_connmark"; then
        if [ ! -f "/lib/modules/4.1.52/extra/$ACT_CONNMARK_NAME" ]; then
            echo "Downloading act_connmark kernel module..."
            if wget -q -O "/tmp/$ACT_CONNMARK_NAME" "$ACT_CONNMARK_URL" && \
               echo "$ACT_CONNMARK_SHA  /tmp/$ACT_CONNMARK_NAME" | sha256sum -c -; then
                mkdir -p /lib/modules/4.1.52/extra
                cp "/tmp/$ACT_CONNMARK_NAME" "/lib/modules/4.1.52/extra/"
                depmod -a 4.1.52 2>/dev/null || true
            else
                echo "WARN: act_connmark download/verify failed, DumaOS QoS filters will not load"
            fi
            rm -f "/tmp/$ACT_CONNMARK_NAME"
        fi
        echo act_connmark > /etc/modules.d/99-dumaos-qos 2>/dev/null || true
        modprobe act_connmark 2>/dev/null || \
            insmod "/lib/modules/4.1.52/extra/$ACT_CONNMARK_NAME" 2>/dev/null || \
            echo "WARN: cannot load act_connmark"
    fi
else
    echo "NOTE: kernel $kver is not 4.1.52 (Damson VBNTJ): skipping act_connmark,"
    echo "      verify the QoS modules (act_connmark, ifb, cls_u32, act_police) manually."
fi

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
