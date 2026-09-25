#!/bin/sh

/etc/init.d/ctwatch stop
mv /dumaos/ctwatch /usr/bin/ctwatch
/etc/init.d/ctwatch start