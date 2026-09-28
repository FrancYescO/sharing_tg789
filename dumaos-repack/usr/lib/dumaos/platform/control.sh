#!/bin/sh

ACTION="$1"

dumaos_running() {
  ps w 2>/dev/null | grep 'cli.lua -p .*com.netdumasoftware.procmanager' | grep -v grep >/dev/null
}

restore_shorthash() {
  mkdir -p /www/data || return 1
  [ ! -s /dumaossystem/version ] || cp /dumaossystem/version /www/data/shorthash || return 1
  chmod 644 /www/data/shorthash 2>/dev/null
}

case "$ACTION" in
  start)
    restore_shorthash || exit 1
    dumaos_running || rm -f /var/run/dumaos-status
    /etc/init.d/ctwatch stop >/dev/null 2>&1
    /etc/init.d/ctwatch disable >/dev/null 2>&1
    /etc/init.d/ctwatch-shim enable >/dev/null 2>&1
    /etc/init.d/ctwatch-shim start >/dev/null 2>&1
    /etc/init.d/ndhttpd enable >/dev/null 2>&1
    /etc/init.d/ndhttpd start >/dev/null 2>&1 || exit 1
    /etc/init.d/dumaos enable >/dev/null 2>&1
    /etc/init.d/dumaos start >/dev/null 2>&1
    ;;
  stop)
    /etc/init.d/dumaos stop >/dev/null 2>&1
    killall -9 dpiclass dpiclass.bin >/dev/null 2>&1
    /etc/init.d/ctwatch-shim stop >/dev/null 2>&1
    /etc/init.d/ctwatch-shim disable >/dev/null 2>&1
    /etc/init.d/ndhttpd stop >/dev/null 2>&1
    ;;
  *)
    echo "Usage: $0 {start|stop}" >&2
    exit 2
    ;;
esac
