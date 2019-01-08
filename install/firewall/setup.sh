#!/bin/sh

control=$(ls /etc/firewall.user.save)

if [ $control == /etc/firewall.user.save ]
then 
     exit 1
     else
         cp /etc/firewall.user /etc/firewall.user.save
         exit 0
fi

exit 1
