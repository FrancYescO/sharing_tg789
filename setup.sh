#!/bin/sh

echo "Installing strongswan..."

opkg install strongswan-default strongswan-pki strongswan-mod-dhcp

vpnclientName="myvpnclient"
orgName="Technicolor"
caName="CATechnicolor"
ddns_domain=$(uci get ddns.myddns_ipv4.domain)
dhcp_broadcast=$(ifconfig br-lan | awk '/inet / {print $3}' | cut -d: -f2)

echo "Generating/Placing conf files..."

echo "config setup

conn %default
 keyexchange=ikev2

conn roadwarrior
 left=%any
 leftauth=pubkey
 leftcert=serverCert.pem
 leftid=$ddns_domain
 leftsubnet=0.0.0.0/0,::/0
 right=%any
 rightsourceip=%dhcp
 rightauth=pubkey
 rightcert=clientCert.pem
 #rightauth2=eap-mschapv2
 auto=add" > /etc/ipsec.conf

echo "dhcp {
  force_server_address = yes
  load = yes
  server = $dhcp_broadcast
}" > /etc/strongswan.d/charon/dhcp.conf

cat << EOF > /etc/ipsec.secrets
: RSA serverKey.pem
remoteusername : EAP "secretpassword"
EOF

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

EOF

cd /tmp

echo "Generating Keys/Cets, it require some time..."

ipsec pki --gen --outform pem > caKey.pem
ipsec pki --self --in caKey.pem --dn "C=US, O=$orgName, CN=$caName" --ca --outform pem > caCert.pem
ipsec pki --gen --outform pem > serverKey.pem
ipsec pki --pub --in serverKey.pem | ipsec pki --issue --cacert caCert.pem --cakey caKey.pem --dn "C=US, O=$orgName, CN=$ddns_domain" --san="$ddns_domain" --flag serverAuth --flag ikeIntermediate --outform pem > serverCert.pem
ipsec pki --gen --outform pem > clientKey.pem
ipsec pki --pub --in clientKey.pem | ipsec pki --issue --cacert caCert.pem --cakey caKey.pem --dn "C=US, O=$orgName, CN=$vpnclientName" --san="$vpnclientName" --outform pem > clientCert.pem

openssl pkcs12 -export -inkey clientKey.pem -in clientCert.pem -name "$vpnclientName" -certfile caCert.pem -caname "$caName" -out "$vpnclientNameCert.p12" -passout pass:

echo "Generated client cert, take it from /tmp/$vpnclientNameCert.p12 !!"

# where to put them...
mv caCert.pem /etc/ipsec.d/cacerts/
mv caKey.pem /etc/ipsec.d/private/
mv serverCert.pem /etc/ipsec.d/certs/
mv serverKey.pem /etc/ipsec.d/private/
mv clientCert.pem /etc/ipsec.d/certs/
mv clientKey.pem /etc/ipsec.d/private/

/etc/init.d/firewall restart
/etc/init.d/ipsec enable
/etc/init.d/ipsec start
