#!/bin/bash

echo "----------------------------------------------------------------------------------------------------------------"
echo "ESTEM APLICANT SSH, APACHE I IPTABLES"
echo "Ets el router, el dmz o cap dels dos?(router/dmz)"
read rol

if [ $rol = "router" ];then
echo "En quina interficie tens internet?"
read interficie
echo "Quina ip tens?"
read ip_rout
echo "Ip del client?"
read ip_cli
echo "Ip del dmz?"
read ip_dmz
echo "Interficie amb la que et conectes al client?"
read interficie_cli
echo "Interficie amb la que et conectes al dmz?"
read interficie_dmz


apt-get install openssh-server
#DNAT
iptables -t nat -A PREROUTING -i $interficie -d $ip_rout -p tcp -m multiport --dports 80,443 -j DNAT --to $ip_dmz
iptables -t nat -A PREROUTING -i $interficie -d $ip_rout -p tcp  --dport 2222 -j DNAT --to $ip_cli:22
iptables -A FORWARD -i $interficie -p tcp -m multiport --dports 80,443 -d 192.18.22.0/28 -j ACCEPT
#SNAT
iptables -t nat -A POSTROUTING -s 172.22.2.0/24 -o $interficie -j MASQUERADE	
iptables -A FORWARD -i $interficie_cli -o $interficie -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $interficie_cli -o $interficie -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.18.22.16/28 -o $interficie -j MASQUERADE	
iptables -A FORWARD -i $interficie_dmz -o $interficie -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $interficie_dmz -o $interficie -j ACCEPT
elif [ $rol = "dmz" ];then
apt-get install apache2
fi
