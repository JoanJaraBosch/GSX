#!/bin/bash

# Authors: Grup1A
# Version: 1.0
# Date: 27/03/2019
# Description: script que pot rebre qualsevol nombre d'usuaris i els activara o deshabilitara depenent de si existeixen o no. Accepta un sol parametre que es el -h per tal de veure ajuda del script.


if [ "$#" -eq 0 ];then
	echo "Error: no has passat cap usuari"
elif [ "$#" -eq 1 ] && [ "$1" = "-h" ];then
	echo "EL scrip reb per parametre tots els usuaris que vulguis i et desectivara o activara l'usuari depenent com estigui actualment"
else
	for usuari in "$@";do
	if [ "$(id -u $usuari 2>/dev/null)" != "" ];then
		numfila=$(grep "$usuari" -n /etc/shadow | cut -d ":" -f 1)
		param=$(grep "$usuari" /etc/shadow | cut -d ":" -f 1)
		param2=$(grep "$usuari" /etc/shadow | cut -d ":" -f 2-)
		if [ "${param2:0:1}" = "!" ];then
			linea="$param:${param2:1:-1}"
			echo "Habilitant l'usuari $usuari"		
		else
			linea="$param:!$param2:"
			echo "Deshabilitant l'usuari $usuari"
		fi	
		sed -i "$numfila""d" /etc/shadow
		echo "$linea" >> /etc/shadow
	fi
	done
fi
