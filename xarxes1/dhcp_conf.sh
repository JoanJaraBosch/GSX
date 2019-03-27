#!/bin/bash



# Script per tal de configurar la dhcp de les maquines. Obte per parametre:



# $1 = client, server o router

# $2 = interficie client

# $3 = interficie server

# $4 = interficie router

# $5 = mac per a la configuracio de la zona

# $6 = ip a eliminar del server o client



if [ $1 = "router" ];then

	ip link set dev $2 up

	ip link set dev $3 up

	cp -p /etc/network/interfaces ~/interficie_router

	echo -e "#generat automàticament per milax-xarxa-estàtica\nauto lo\niface lo inet loopback\n\n#CONEXIO DMZ\nallow-hotplug $3\niface $3\ninet static\n\taddress 198.18.22.1/28\n\nallow-hotplug $5\nauto $5iface $5inet dhcp\n\ɲauto $2\nallow-hotplug $2\niface $2 inet static\naddress 172.22.2.1/24" > /etc/network/interfaces

	ifdown $2

	ifdown $3

	ifdown $4

	ifup $2

	ifup $3

	ifup $4

	cp -p /etc/dhcp/dhcpd.conf ~/dhcp_conf_router

	echo -e "default-lease-time 600;\nmax-lease-time 7200;\nauthoritative;\n\nsubnet 172.22.2.0 netmask 255.255.255.0 {\nrange 172.22.2.1\n172.22.2.254;\noption subnet-mask 255.255.255.0;\noption broadcast-address 172.22.2.255;\noption routers 172.22.2.1;\noption domain-name-servers 172.22.2.1;\noption domain-name "'interna'";\nmax-lease-time 604800; # 604800 sg = una setmana\ndefault-lease-time 604800; # sobreposa al global\n}\n\n# Configuracio DMZ:\nsubnet 198.18.22.0 netmask 255.255.255.240 {\nrange 198.18.22.1 198.18.22.14;\noption subnet-mask 255.255.255.240;\noption broadcast-address 198.18.22.15;\noption routers 198.18.22.1;\noption domain-name-servers 198.18.22.1;\noption domain-name "'L2G2.gsx'";\nmax-lease-time 604800; # 604800 sg = una setmana\ndefault-lease-time 604800; # sobreposa al global\n}\n\nhost dmz-server {\n\thardware ethernet $5;\n\tfixed-address 198.18.22.16;\n}\n" > /etc/dhcp/dhcpd.conf

	

	cp -p /etc/default/isc-dhcp-server ~/interfaces_dhcp_router



	echo "INTERFACESv4="$2 $3"" > /etc/default/isc-dhcp-server



	systemctl restart isc-dhcp-server

elif [ $1 = "client" ] || [ $1 = "server" ];then

	ip addr del $6 dev enp2s0

	cp -p /etc/network/interfaces ~/interficie_server_client

	echo > /etc/network/interfaces

	echo -e "allow-hotplug enp2s0\nauto enp2s0\niface enp2s0 inet dhcp\n" > /etc/network/interfaces

	ifdown enp2s0

	ifup enp2s0

else

	echo "T'has equivocat al introduir el primer parametre. Parametres del script (param1=client, server o router. param2 = interficie client, param3 = interficie server, param4 = interficie router, param5= adressa mac, param6= ip que volem eliminar del server o el client)"

fi