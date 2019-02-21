#!/bin/bash

# Authors: Jose Angel Morena, Aleix Iglesias i Joan Jara
# Date: 21/02/2019
# Version: 1.0
# Description: Aquest script serveix per aturar processos que han estat 5 minuts consumint cpu amb 1gb o més de memoria. A les 9 de la nit els reengegaria i si a les 8 del dia següent no han acabat els tornaria a apagar. Per tant de 8 del mati a 9 de la nit anira mirant els processos que compleixin aquesta condicio i a partir de les 9 de la nit els reengegara (nomes dies laborables). Només pot rebre un parametre (-h) per demanar ajuda. 

if [ "$#" -eq 1 ];then
	echo "Aquest script no necessita cap parametre, s'executa amb el crontab i pausa processos que estan 5 minuts o mes i ocupen 1gb o mes en dies laborables de 8 a 21. A partir de les 21 els deix continuar"

elif [ "$#" -eq 0 ];then

	hora=$(date +"%H")

	if [ $hora -ge 8 ] && [ $hora -lt 21 ];then
		for proces in $(ps -da -o pid,size,time,state | grep -v T | awk '$2 >= 1048576 {print $0 }' | tr : " " | awk '$5>=5 {print $1}');
		do
			echo $proces && kill -19 $proces
		done
	else
		for proces in $(ps -da -o pid,state | grep T | awk '{print $1}');do
			echo $proces && kill -18 $proces
		done
	fi
else
	echo "Aquest script no rep parametres o si en rep, en rep 1 (-h) per ajudar al usuari"
fi
