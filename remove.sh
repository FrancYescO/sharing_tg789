#!/bin/sh
/etc/init.d/asterisk stop
/etc/init.d/asterisk disable
/etc/init.d/asterisk-gui disable
opkg remove asterisk13-app-exec
opkg remove asterisk13-app-system
opkg remove asterisk13-chan-iax2
opkg remove asterisk13-res-timing-timerfd
opkg remove asterisk13
opkg remove libncurses
opkg remove terminfo
rm /bin/hostname
rm -r /etc/asterisk
rm -r /usr/share/asterisk
rm -r /usr/lib/asterisk
rm -r /var/lib/asterisk