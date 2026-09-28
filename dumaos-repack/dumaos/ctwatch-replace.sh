#!/bin/sh

/etc/init.d/ctwatch stop 2>/dev/null
killall ctwatch 2>/dev/null
/etc/init.d/ctwatch disable 2>/dev/null
/etc/init.d/ctwatch-shim enable
/etc/init.d/ctwatch-shim restart
