#!/bin/sh
         
control=$(ls /etc/firewall.user.save)

if [ $control == /etc/firewall.user.save ]
then 
     echo "Coonfiguring Firewall"
     else
         echo "Firewall: Notting to do!"
         exit 1
fi

cp /etc/firewall.user.save /etc/firewall.user

amule=$(opkg list-installed | grep amule | cut -c1-5)

if [ $amule == amule ]
then 
     cat /mnt/usb/USB-A1/sharing/install/firewall/firewall.amule >> /etc/firewall.user
     else
         echo "amule not installed"
fi

aria2=$(opkg list-installed | grep aria2 | cut -c1-5)

if [ $aria2 == aria2 ]
then 
     cat /mnt/usb/USB-A1/sharing/install/firewall/firewall.aria2 >> /etc/firewall.user
     else
         echo "aria2 not installed"
fi

echo "Firewall: Restart!"

/etc/init.d/firewall restart

echo Done

exit 1


