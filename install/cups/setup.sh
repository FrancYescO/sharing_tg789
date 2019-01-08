#!/bin/sh 
sed -i.save 's/no/yes/' /etc/init.d/cupsd & /etc/init.d/cupsd enable & /etc/init.d/cupsd start
cupsctl WebInterface=yes
