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
		numfila=$(grep "$usuari" -n /home/milax/shadow | cut -d ":" -f 1)
		linea=$(grep "$usuari" /home/milax/shadow | cut -d "$" -f 4)
		part1=$(grep "$usuari" /home/milax/shadow | cut -d "$" -f 1)
		part2=$(grep "$usuari" /home/milax/shadow | cut -d "$" -f 2)
		part3=$(grep "$usuari" /home/milax/shadow | cut -d "$" -f 3)
		if [ "${linea:0:1}" = "!" ];then
			linea="$part1$""$part2$""$part3$""${linea:1:-1}"
			echo "Habilitant l'usuari $usuari"		
		else
			linea="$part1$""$part2$""$part3$""!${linea:0:-1}"
			echo "Deshabilitant l'usuari $usuari"
		fi	
		sed -i "$numfila""d" /home/milax/shadow
		echo "$linea" >> /home/milax/shadow
	fi
	done
fi
