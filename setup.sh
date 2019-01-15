#!/bin/sh

opkg install terminfo
opkg install libncurses
opkg install asterisk13
opkg install asterisk13-res-timing-timerfd
opkg install asterisk13-chan-iax2
opkg install asterisk13-app-system
opkg install asterisk13-app-exec
cp -r asterisk-gui_data/* /
cp *.conf /etc/asterisk/
mkdir -p /usr/lib/asterisk/sounds/en
cp demo-echotest.alaw /usr/lib/asterisk/sounds/en
chmod -R 755 /etc/asterisk
chmod -R 755 /usr/lib/asterisk
#chmod 755 /etc/init.d/asterisk
chmod 755 /etc/init.d/asterisk-gui
chmod 755 /bin/hostname
rm -R /var/lib/asterisk
/etc/init.d/asterisk enable
/etc/init.d/asterisk-gui enable
/etc/init.d/asterisk-gui restart
sudo ln -s /var/lib/asterisk/static-http/ /usr/share/asterisk/static-http
/etc/init.d/asterisk restart
start.sh