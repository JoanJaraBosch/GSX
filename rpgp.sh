#!/bin/bash
#Autors: Grup 1A; Jose Angel Morena, Joan Jara, Aleix Iglesias
#Descripcio: Script que configura els permisos dels fitxers que se troben a un fitxer que es passa per parametre


usage()
{

	echo "Que fa el script?Rep un fitxer per parametre i modifica els permisos dels determinats fitxers, preguntant al usuari, fitxer per fitxer."
	echo "Quines opcions admet?No admet cap opció."
	echo "Quins parametres hem de posar?Hem de passar un fitxer per parametre, no admet més parametres."
	echo "Es pot executar per qualsevol usuari"

}

wrong_option(){

	echo "Nomes s'admet l'opcio 'h'... no cap altra" 
}


while getopts "h" o; do #OPCIO H d'ajut
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

if [[ -e "$1" && -f "$1" ]]; then	#SI EXISTEIX EL FITXER QUE ES PASSA PER PARAMETRE
	while read nom grup permisos fitxer; do	#LLEGIM EL FITXER, CAMP PER CAMP
		if [ -e "$fitxer" ]; then
			u=$(stat -c %U "$fitxer")	
			g=$(stat -c %G "$fitxer")
			p=$(stat -c %a "$fitxer")
			if [[ "$p" != "$permisos" || "$u" != "$nom" || "$g" != "$grup" ]]; then	#SI ELS PERMISOS SON DIFERENTS
				echo "Informacio al fitxer: $nom , $grup, $permisos, $fitxer"
				echo "Informacio real/actual: $u, $g, $p, $fitxer"
				read -p "Esta segur de modificar els permisos per a aquests (y/n)" yn < /dev/tty	#PREGUNTEM SI ES VOLEN MODFICAR ELS PERMISOS I REDIRIGIM AL TERMINAL
				if [[ $yn == 'Y' || $yn == 'y' ]]; then
					if [ "$p" != "$permisos" ]; then
						if  chmod $permisos "$fitxer" ; then	#EXECUTEM CHMOD
							echo "Els permisos del fitxer: $fitxer, han sigut modificats"
						else
							if [ $? -ne 0 ]; then 
								echo "Codi d'error:  $?"
				 			fi
					 	fi		
					fi
					if [ "$u" != "$nom" ]; then
						if chown $nom "$fitxer" ; then	#EXECUTEM CHOWN
							echo "El propietari del fitxer: $fitxer, ha canviat a $nom"
						else
							if [ $? -ne 0 ]; then 
								echo "Codi d'error:  $?"
				 			fi						
						fi

					fi
					if [ "$g" != "$grup" ]; then
						if chgrp $grup "$fitxer" ; then	#EXECUTEM CHGRP
							echo "El grup del fitxer: $fitxer, ha canviat a $grup"
						else
							if [ $? -ne 0 ]; then 
								echo "Codi d'error:  $?"
				 			fi					
						fi
					fi					
				
				fi
				echo
			fi
		else 
			echo "Error: El fitxer $fitxer no existeix" >&2	#MOSTRA ERROR SI EL FITXER DE PARAMETRE NO EXISTEIX
		fi
	done < "$1"	
else
	echo "No existeix el fitxer o es un directori... $1" >&2
fi

exit 0
