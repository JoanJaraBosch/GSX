#!/bin/bash

# Script per tal de configurar la dhcp de les maquines. Obte per parametre:

echo "----------------------------------------------------------------------------------------------------------------"
echo "ESTEM APLICANT DHCP"

echo "Quin rol vols fer? (client/server/router)"

read rol

# $2 = interficie client

# $3 = interficie server

# $4 = interficie router

# $5 = mac per a la configuracio de la zona



if [ $rol = "router" ];then
	apt-get install isc-dhcp-server
	echo "1" > /proc/sys/net/ipv4/ip_forward

	echo "Interficie per al client?"
	read client
	echo "Interficie per al server?"
	read server
	echo "Interficie per al router?"
	read router
	echo "Mac del client?"
	read macClien

	cp -p /etc/network/interfaces ~/interficie_router

	echo -e "#generat automàticament per milax-xarxa-estàtica\nauto lo\niface lo inet loopback\n\n#CONEXIO DMZ\nallow-hotplug $server \niface $server inet static\n\taddress 198.18.22.1/28\n\nallow-hotplug $router \nauto $router\niface $router inet dhcp\n auto $client\nallow-hotplug $client\niface $client inet static\naddress 172.22.2.1/24" > /etc/network/interfaces

	ifdown $client

	ifdown $server

	ifdown $router

	ifup $client

	ifup $server

	ifup $router

	cp -p /etc/dhcp/dhcpd.conf ~/dhcp_conf_router

	echo -e "default-lease-time 600;\nmax-lease-time 7200;\nauthoritative;\n\nsubnet 172.22.2.0 netmask 255.255.255.0 {\nrange 172.22.2.1 172.22.2.254;\noption subnet-mask 255.255.255.0;\noption broadcast-address 172.22.2.255;\noption routers 172.22.2.1;\noption domain-name-servers 172.22.2.1;\noption domain-name "'interna'";\nmax-lease-time 604800; # 604800 sg = una setmana\ndefault-lease-time 604800; # sobreposa al global\n}\n\n# Configuracio DMZ:\nsubnet 198.18.22.0 netmask 255.255.255.240 {\nrange 198.18.22.1 198.18.22.14;\noption subnet-mask 255.255.255.240;\noption broadcast-address 198.18.22.15;\noption routers 198.18.22.1;\noption domain-name-servers 198.18.22.1;\n#option domain-name "'L2G2.gsx'";\nmax-lease-time 604800; # 604800 sg = una setmana\ndefault-lease-time 604800; # sobreposa al global\n}\n\nhost dmz-server {\n\thardware ethernet $macClien;\n\tfixed-address 198.18.22.16;\n}\n" > /etc/dhcp/dhcpd.conf

	cp -p /etc/default/isc-dhcp-server ~/interfaces_dhcp_router



	echo 'INTERFACESv4="'$client' '$server'"' > /etc/default/isc-dhcp-server



	systemctl restart isc-dhcp-server

elif [ $rol = "client" ] || [ $rol = "server" ] ;then
	
	echo "Quina interficie tens conectada al router?"
	read interficie

	cp -p /etc/network/interfaces ~/interficie_server_client

	echo > /etc/network/interfaces

	echo -e "allow-hotplug $interficie\nauto $interficie\niface $interficie inet dhcp\n" > /etc/network/interfaces

	ifdown $interficie

	ifup $interficie

else

	echo "No has introduit el rol correctament"
fi
