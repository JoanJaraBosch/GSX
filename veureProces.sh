#!/bin/bash

# Authors: Jose Angel, Aleix Iglesias i Joan Jara
# Date: 24/02/2019
# Version: 1.0
# Description: Script per a veure els usuaris que han engegat un proces entre la 13:00h i les 14:59 i el proces ha acabat per un sigterm (x) o per un fitxer core (d). EL script no necessita parametres pero se li pot pasar un per demanar ajuda(-h). A mes a mes, nomes es pot executar com a superusuari ja que la comanda lastcomm nomes la pot executar el superusuari.

if [ "$#" -eq 1 ];then
	echo "Aquest script es per veure la comanda i lusuari que han creat un proces entre les 13:00 i les 14:59h. NO necessita parametres pero sha dexecutar com a superusuari"
elif [ "$#" -eq 0 ];then
	lastcomm | grep -e D -e X | tr F " " | tr : " " | awk '{if (( $10 ==13 || $10 ==14 ) && ($11>=0 && $11 <=59)) print "Commnad: " $1 " User: "$3  } '
else
	echo "Aquest script no necessita cap parametre, nomes el -h si necessites ajuda. A mes a mes nomes es pot executar com a superusuari"
fi
