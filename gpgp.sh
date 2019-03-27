#!/bin/bash
#Authors: Group 1A, Jose Angel Morena, Aleix Iglesias i Joan Jara
#Date: 06/02/2019
#Description: 


usage()
{

	echo "Que fa el script?Aquest script, llegeix d'un fitxer on se troben diferents paths absoluts, agafa path per path i mostra els seus permisos al mateix temps que els escriu en un fitxer 'permissions.txt'."
	echo "Quines opcions admet?No admet cap opció."
	echo "Quins parametres hem de posar?Hem de passar un fitxer per parametre, no admet més parametres."
	echo "Es pot executar per qualsevol usuari"

}

wrong_option(){

	echo "Nomes s'admet l'opcio 'h'... no cap altra" 
}


while getopts "h" o; do #OPCIO h D'AJUT
	case "${o}" in
		h)
			usage
			exit 0
			;;
		*)
			wrong_option
			exit 1
			;;
	esac
done


shift $((OPTIND-1))


if [[ $# -eq 0 || -z "$1" ]]; then	#CONTROL NUMERO D'ARGUMENTS
	echo "No has posat argument (path al fitxer)"
 	exit 2
fi       

if [[ -e "$1" && -f "$1" ]]; then	#SI EXISTEIX EL FITXER I NO ES UN DIRECTORI
	IFS=$'\n'	#ESPECIFIQUEM 'TOQUEN' ES EL CARACTER DE SALT DE LINEA
	for fitxer in $(cat "$1");do	# PER A CADASCUN DELS FITXERS QUE HI HAN
		if [ -e $fitxer ]; then	#SI EXISTEIX EXECUTEM LA COMANDA stat
			stat -c "%U %G %a %n" $fitxer | tee -a ./permissions.txt	#POSEM AL FITXER AL MATEIX TEMPS QUE A LA SORTIDA STANDARD
		else
			echo "Error Fitxer $fitxer no existeix o es tracta de un directori" >&2	#SI NO EXISTEIX EL FITXER, POSEM ERROR
		fi
	done
	unset IFS
else 	#SI EL FITXER QUE ES PASSA PER PARAMETRE NO EXISTEIX O ES UN DIRECTORI ES MOSTRA ERROR
	echo "Error Fitxer "$1" no existeix o es tracta de un directori" >&2

fi

exit 0
