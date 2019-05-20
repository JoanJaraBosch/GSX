#!/bin/bash

echo "---------------------------------------------------------------------------------"
echo "ESTEM APLICANT SSH, APACHE I IPTABLES"
echo "Ets el router, el dmz o cap dels dos?(router/dmz)"
read rol

if [ $rol = "router" ];then
echo "En quina interficie tens internet?"
read interficie
echo "Quina ip tens?"
read ip_rout
echo "Ip del server de la dmz?"
read ip_dmz
echo "Interficie amb la que et conectes al client?"
read interficie_cli
echo "Interficie amb la que et conectes al dmz?"
read interficie_dmz


apt-get install openssh-server
#guardar iptables
iptables-save > ~/iptables_guardat
#eliminar iptables
iptables -F
iptables -X
#politiques
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
#comunicacio snat
iptables -t nat -A POSTROUTING -p tcp -o $interficie_cli -j SNAT --to-source $ip_rout:1024-32000
iptables -t nat -A POSTROUTING -p tcp -o $interficie_dmz -j SNAT --to-source $ip_rout:1024-32000
#comunicacio dnat
iptables -A FORWARD -i $interficie -p tcp -m multiport --dports 22,80,443,2222,8080 -d 198.18.2.16/28 -j ACCEPT
iptables -t nat -A PREROUTING -i $interficie -p tcp -m multiport --dports 22,80,443,2222,8080 -j DNAT --to $ip_dmz

elif [ $rol = "dmz" ];then
apt-get install apache2
fi
