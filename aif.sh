#! /bin/bash

#Authors: Group 1A, Jose Angel Morena, Aleix Iglesias i Joan Jara
#Date: 06/02/2019
#Version: 1.0
#Description: This script will configure a network file. It needs six parameters: the file, the address, the mask, the network, the gateway and    
#             finally the network interface. Only accepts option, the -h option to show you help if you execute incorrectly the script. Finally,   
#             this script is only executable by the root or super user because its main purpouse is modify the network interfaces file and only a 
#             super user is able to modify this file.

if [ "$(whoami)" == "root" ] ; then
	if [ $# -eq 0 ]; then
        	echo "Error: parametres insuficients, has de posar 6 parametres(adressa fitxer, adressa, mask, network, gateway i el network interface) o"
		echo "1 per a demanar ajuda de com funciona el script"
	elif [ $# -eq 1 ] && [ $@ == "-h" ]; then 
        	echo "Aquest script serveix per a configurar un fitxer de red introduit per parametre. Nomes el pot executar el usuari root i necessita"
		echo "6 parametres (addressa, fitxer, mask, network, gateway i el nework interface) o 1 parametre per demanar ajuda (-h)"
	elif [ $# -eq 6 ]; then
		#posarem el echo amb la opcio -e per aixi detectar els \n i els \t per a fer-ho amb una sola linea i finalment posarem || per si la comanda no es pot executar per algun error com per exemple ladressa del fitxer esta mal posada.
		echo -e "auto "$6"\niface "$6" inet static\n\taddress "$2"\n\tnetmask "$3"\n\tnetwork "$4"\n\tgateway" $5 > $1 || echo "Error: introdueix les dades correctament, 6 parametres per a executar el script (adressa fitxer, adressa ip, netmask, network, gateway i network interface) o 1 parametre (-h) per a demanar ajuda de com s'ha d'executar el fitxer"
	else
		echo "Has de passar 6 parametres(adressa del fitxer, adressa ip, mask, network, gateway i el network interface) o 1 parametre en cas de volguer ajuda"
	fi
else
	echo error >&2 "This script should not be run using sudo or as the root user"
	exit 1
fi
