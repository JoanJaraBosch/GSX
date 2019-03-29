#!/bin/bash

# Authors: Grup1A
# Version: 1.0
# Date: 29/03/2019
# Description: script que pot rebre qualsevol grup secundari i si 'usuari i pertany obrira una terminal amb el grup secundari actiu per tal de treballari i quan acabi guardara informacio del temps, data i usuari que ha estat en aquest grup secundari. Accepta un sol parametre que es el -h per tal de veure ajuda del script o el grup secundari.


if [ "$#" -eq 0 ];then
	echo "Error: no has passat cap usuari"
elif [ "$#" -eq 1 ] && [ "$1" = "-h" ];then
	echo "EL scrip reb per parametre un grup secundari i guarda informacio del temps que ha estat actiu, per quin user i quin dia"
else
	for grup in $(groups $USER | cut -d ":" -f 2);do
		if [ $1 = $grup ];then
			mkdir -p /home/milax/root/temps
			data=$(date +"%d-%m-%Y")
			echo "Usuari $USER data $data amb els seguents temps: $TIMEFORMAT" >> /home/milax/root/temps/.$grup
			temps=$(\time -p -ao /home/milax/root/temps/.$grup newgrp $grup)
			echo "" >> /home/milax/root/temps/.$grup
			exit 0
		fi
	done
	echo "O no existeix el grup, o no pertanys en aquest grup"
	exit 1
fi
