#!/bin/sh

control=$(ls /www/gateway-snippets/header.lp.save)

if [ $control == /www/gateway-snippets/header.lp.save ]
then 
     echo "Gateway: Configure!"
     cp /www/gateway-snippets/header.lp.new /www/gateway-snippets/header.lp
     else
         echo "Gateway:Notting to do!"
         exit 1
fi

cups=$(ls /etc/init.d/cupsd.save)

if [ $cups == /etc/init.d/cupsd.save ]
then 
     sed -i 's/--cups//' /www/gateway-snippets/header.lp
     else
         echo "cups not select"
fi

amule=$(opkg list-installed | grep amule | cut -c1-5)

if [ $amule == amule ]
then 
     sed -i 's/--amule//' /www/gateway-snippets/header.lp
     else
         echo "amule not installed"
fi

transmission=$(opkg list-installed | grep transmission-daemon | cut -c1-12)

if [ $transmission == transmission ]
then 
     sed -i 's/--tran//' /www/gateway-snippets/header.lp
     else
         echo "transmission not installed"
fi

aria2=$(opkg list-installed | grep aria2 | cut -c1-5)

if [ $aria2 == aria2 ]
then 
     sed -i 's/--aria2//' /www/gateway-snippets/header.lp
     else
         echo "aria2 not installed"
fi

/etc/init.d/nginx restart

echo Done

exit 1


