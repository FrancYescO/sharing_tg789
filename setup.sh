#!/bin/sh

echo "Installing strongswan..."

opkg install strongswan-default strongswan-pki strongswan-mod-dhcp
opkg list | grep fox  | awk '{print $1}' | xargs opkg install

COUNTRYNAME="US"
CANAME="CATechnicolor"
ORGNAME="Technicolor"
CACERTPASSWORD="" #if set will be asked when installing cert on clients or generating new clientCert
SERVERDOMAINNAME=$(uci get ddns.myddns_ipv4.domain) #"myvpnserver.dyndns.org"
CLIENTNAMES="myvpnclient1" # or more " … myvpnclient2 muvpnclient3"
SHAREDSAN="myVpnClients" # iOS clients need to match a common SAN

dhcp_broadcast=$(ifconfig br-lan | awk '/inet / {print $3}' | cut -d: -f2)

echo "Generating/Placing conf files..."

echo "config setup

conn %default
        keyexchange=ikev2
        ike=aes256-aes128-sha256-sha1-modp3072-modp2048-modp1024
        left=%any
        leftauth=pubkey
        leftcert=serverCert_$SERVERDOMAINNAME.pem
        leftid=$SERVERDOMAINNAME
        leftsubnet=0.0.0.0/0;::/0
        right=%any
        rightsourceip=%dhcp
        eap_identity=%identity
        auto=add

conn rwEAPMSCHAPV2
        leftsendcert=always
        rightauth=eap-mschapv2
        rightsendcert=never

conn rwPUBKEYIOS
        leftsendcert=always
        rightid=SHAREDSAN
        rightauth=pubkey
        rightca=caCert.pem
        #rightauth2=eap-mschapv2

conn rwEAPTLSIOS
        leftsendcert=always
        rightid=SHAREDSAN
        rightauth=eap-tls
        rightcert=caCert.pem
        #rightauth2=eap-mschapv2

conn rwPUBKEY
        rightauth=pubkey
        rightcert=caCert.pem
        #rightauth2=eap-mschapv2

conn rwEAPTLS
        rightauth=eap-tls
        rightcert=caCert.pem" > /etc/ipsec.conf

echo "dhcp {
  force_server_address = yes
  load = yes
  server = $dhcp_broadcast
}" > /etc/strongswan.d/charon/dhcp.conf

echo ": RSA serverKey_$SERVERDOMAINNAME.pem
remoteusername : EAP \"secretpassword\"" > /etc/ipsec.secrets

cat << EOF >> /etc/config/firewall

config rule 'ipsec_esp'
	option src 'wan'
	option name 'IPSec ESP'
	option proto 'esp'
	option target 'ACCEPT'

config rule 'ipsec_ike'
	option src 'wan'
	option name 'IPSec IKE'
	option proto 'udp'
	option dest_port '500'
	option target 'ACCEPT'

config rule 'ipsec_nat_traversal'
	option src 'wan'
	option name 'IPSec NAT-T'
	option proto 'udp'
	option dest_port '4500'
	option target 'ACCEPT'

config rule 'ipsec_auth_header'
	option src 'wan'
	option name 'Auth Header'
	option proto 'ah'
	option target 'ACCEPT'
EOF

cat << EOF >> /etc/firewall.user

#strongswan ipsec
iptables -I INPUT  -m policy --dir in --pol ipsec --proto esp -j ACCEPT
iptables -I FORWARD  -m policy --dir in --pol ipsec --proto esp -j ACCEPT
iptables -I FORWARD  -m policy --dir out --pol ipsec --proto esp -j ACCEPT
iptables -I OUTPUT   -m policy --dir out --pol ipsec --proto esp -j ACCEPT
iptables -t nat -I POSTROUTING -m policy --pol ipsec --dir out -j ACCEPT

EOF

cd /tmp

echo "Building certificates for [ $SERVERDOMAINNAME ] and client [ $CLIENTNAME (aka $SHAREDSAN) ] "

[ -f "/etc/ipsec.d/private/ca.p12" ] && ln -s /etc/ipsec.d/private/ca.p12 ca.p12

if [ -f "caKey.pem" ] ; then
  echo "caKey exists, using existing caKey for signing serverCert and clientCert...."
elif [ -f "ca.p12" ] ; then
  echo "CA keys bundle exists, accessing existing protected caKey for signing serverCert and clientCert...."
  openssl pkcs12 -in ca.p12 -nocerts -out caKey.pem
else
  echo "generating a new cakey for [ $CANAME ]"
  ipsec pki --gen --outform pem > caKey.pem
fi
echo "generating caCert for [ $CANAME ]..."
ipsec pki --self --lifetime 3652 --in caKey.pem --dn "C=$COUNTRYNAME, O=$ORGNAME, CN=$CANAME" --ca --outform pem > caCert.pem
openssl x509 -inform PEM -outform DER -in caCert.pem -out caCert.crt
echo "Now building CA keys bundle"
openssl pkcs12 -export -inkey caKey.pem -in caCert.pem -name "$CANAME" -certfile caCert.pem -caname "$CANAME" -out ca.p12 -password "pass:$CACERTPASSWORD"

echo "generating server certificates for [ $SERVERDOMAINNAME ]... "
ipsec pki --gen --outform pem > serverKey_$SERVERDOMAINNAME.pem
ipsec pki --pub --in serverKey_$SERVERDOMAINNAME.pem | ipsec pki --issue --lifetime 3652 --cacert caCert.pem --cakey caKey.pem --dn "C=$COUNTRYNAME, O=$ORGNAME, CN=$SERVERDOMAINNAME" --san="$SERVERDOMAINNAME" --flag serverAuth --flag ikeIntermediate --outform pem > serverCert_$SERVERDOMAINNAME.pem
#openssl x509 -inform PEM -outform DER -in serverCert_$SERVERDOMAINNAME.pem -out serverCert_$SERVERDOMAINNAME.crt

for CLIENTNAME in $CLIENTNAMES; do
  if [ -f "clientCert_$CLIENTNAME.pem" ] ; then
    echo "clientCert for [ $CLIENTNAME ] exists, not generating new clientCert."
    continue
  fi
  echo "generating clientCert for [ $CLIENTNAME (aka $SHAREDSAN) ]..."
  ipsec pki --gen --outform pem > clientKey_$CLIENTNAME.pem
  ipsec pki --pub --in clientKey_$CLIENTNAME.pem | ipsec pki --issue --lifetime 3652 --cacert caCert.pem --cakey caKey.pem --dn "C=$COUNTRYNAME, O=$ORGNAME, CN=$CLIENTNAME" --san="$CLIENTNAME" --san="$SHAREDSAN" --outform pem > clientCert_$CLIENTNAME.pem
  openssl x509 -inform PEM -outform DER -in clientCert_$CLIENTNAME.pem -out clientCert_$CLIENTNAME.crt
  echo "Now building Client keys bundle for [ $CLIENTNAME ]"
  openssl pkcs12 -export -inkey clientKey_$CLIENTNAME.pem -in clientCert_$CLIENTNAME.pem -name "$CLIENTNAME" -certfile caCert.pem -caname "$CANAME" -out client_$CLIENTNAME.p12 -password "pass:$CACERTPASSWORD"
  rm clientKey_$CLIENTNAME.pem
  openssl x509 -inform PEM -outform DER -in clientCert_$CLIENTNAME.pem -out clientCert_$CLIENTNAME.crt
done

# where to put them...
mv caCert.pem /etc/ipsec.d/cacerts/
mv serverCert*.pem /etc/ipsec.d/certs/
mv serverKey*.pem /etc/ipsec.d/private/
mv clientCert*.pem /etc/ipsec.d/certs/

#These file are not needed on the modem
[ ! -f "/etc/ipsec.d/private/ca.p12" ] && mv ca.p12 /etc/ipsec.d/private/ #needed to generate new clients
mv client_*.p12 /etc/ipsec.d/private/
mv clientCert_*.crt /etc/ipsec.d/private/

/etc/init.d/firewall restart
/etc/init.d/ipsec enable
/etc/init.d/ipsec start
