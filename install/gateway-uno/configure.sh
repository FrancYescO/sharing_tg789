#!/bin/sh

control=$(ls /www/docroot/gateway.lp.save)

if [ $control == /www/docroot/gateway.lp.save ]
then 
     echo "Gateway: Configure!"
     cp /www/docroot/gateway.lp.new /www/docroot/gateway.lp
     else
         echo "Gateway:Notting to do!"
         exit 1
fi

cups=$(ls /etc/init.d/cupsd.save)

if [ $cups == /etc/init.d/cupsd.save ]
then 
     sed -i 's/--cups//' /www/docroot/gateway.lp
     else
         echo "cups not select"
fi

amule=$(opkg list-installed | grep amule | cut -c1-5)

if [ $amule == amule ]
then 
     sed -i 's/--amule//' /www/docroot/gateway.lp
     else
         echo "amule not installed"
fi

transmission=$(opkg list-installed | grep transmission-daemon | cut -c1-12)

if [ $transmission == transmission ]
then 
     sed -i 's/--tran//' /www/docroot/gateway.lp
     else
         echo "transmission not installed"
fi

aria2=$(opkg list-installed | grep aria2 | cut -c1-5)

if [ $aria2 == aria2 ]
then 
     sed -i 's/--aria2//' /www/docroot/gateway.lp
     else
         echo "aria2 not installed"
fi

/etc/init.d/nginx restart

echo Done

exit 1


