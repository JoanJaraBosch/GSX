#! /bin/bash

#Authors: Group 1A, Jose Angel Morena, Aleix Iglesias i Joan Jara
#Date: 06/02/2019
#Version: 1.0
#Description: Aquest script serveix per a buidar el contingut d'un fitxer passat per parametre. Com que el pot executar qualsevol usuari, si un #fitxer és important, no podra ser borrat ja que no tindra els permisos per a ser buidat per a qualsevol usuari.

#comprovem que nomes tenim un parametre
if [ $# -eq 1 ]; then
	if [ "$@" = "-h" ];then
		echo "Aquest script el pot executar qualsevol usuari . Serveix per a buidar el contingut d'un fitxer passat per parametre, per tant voldrem que ens passis el path absolut del fitxer o la opcio -h per a mostrarte aquest missatge. Aquest script no te permissos per a eliminar fitxers especials ja que no te permissos de root, es a dir, nomes el root podra buidar fitxers especials com el /network/interfaces si es que hi han els permissos en el fitxer."
	#aquet elif el fem per comprovar que ens passen un fitxer i que existeix	
	elif [ -e "$1" ]; then
		if [ -f "$1" ];then
			cat /dev/null > "$1"
		elif [ -d "$1" ];then
			echo "No pots buidar un directori"
		fi
	else
		echo "No existeix el fitxer que vols buidar. Estas segur@ que has passat la adressa del fitxer correctament?"
	fi
else
	echo "Aquest script només accepta un parametre, o la opcio -h per ajuda o el fitxer per a ser buidat"
fi
