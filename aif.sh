#! /bin/bash

#Authors: Group 1A, Jose Angel Morena, Aleix Iglesias i Joan Jara
#Date: 06/02/2019
#Version: 1.0
#Description: This script will configure a network file. It needs six parameters: the file, the address, the mask, the network, the gateway and    
#             finally the network interface. Only accepts option, the -h option to show you help if you execute incorrectly the script. Finally,   
#             this script is only executable by the root or super user because its main purpouse is modify the network interfaces file and only a 
#             super user is able to modify this file.

#utilitzem aquesta condicio amb el whoami en cas que ens equivoquessim i li donguessim permisos per a executar-ho a qualsevol usuari que 
#comproves que ets super usuari o root
if [ "$(whoami)" == "root" ] ; then
	if [ $# -eq 0 ]; then
        echo "Error: parametres insuficients, has de posar 6 parametres(adressa fitxer, adressa, mask, network, gateway i el network interface) o"
		echo "1 per a demanar ajuda de com funciona el script"
	elif [ $# -eq 1 ] && [ $@ == "-h" ]; then 
        echo "Aquest script serveix per a configurar un fitxer de red introduit per parametre. Nomes el pot executar el usuari root i necessita"
		echo "6 parametres (addressa fitxer, adressa, mask, network, gateway i el nework interface) o 1 parametre per demanar ajuda (-h)"
	elif [ $# -eq 6 ]; then
		#Fem aquet if per comprovar que tingui forma de ip i no pas un numero qualsevol o un string ( [[]] perque a dintre evaluem amb operadors) i el =~ serveix per a comparar un string amb un operador per tant comprovem que la nostra, netmask ... tinguin forma de adressa
		if [ -e "$1" ] && [ -f "$1" ];then 
			if [[ $2 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
				if [[ $3 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
					if [[ $4 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
						if [[ $5 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
							OIFS=$($IFS)
							IFS='.'
							#Aqui canviem el IFS per separar per punts per tindre cada part de la ip 
							ip=($2)
							netmask=($3)
							network=($4)
							gateway=($5)
							IFS=$($OIFS)
							#I un cop separat per punts fem aquest if per veure que esta dintre el rang de ip
							if [[ ${ip[0]} -le 255 && ${ip[1]} -le 255  && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]];then
								#posarem el echo amb la opcio -e per aixi detectar els \n i els \t per a fer-ho amb una sola linea i finalment posarem || per si la comanda no es pot executar per algun error com per exemple ladressa del fitxer esta mal posada.
								if [[ ${netmask[0]} -le 255 && ${netmask[1]} -le 255  && ${netmask[2]} -le 255 && ${netmask[3]} -le 255 ]];then
									if [[ ${network[0]} -le 255 && ${network[1]} -le 255  && ${network[2]} -le 255 && ${network[3]} -le 255 ]];then
										if [[ ${gateway[0]} -le 255 && ${gateway[1]} -le 255  && ${gateway[2]} -le 255 && ${gateway[3]} -le 255 ]];then
											echo -e "auto "$6"\niface "$6" inet static\n\taddress "$2"\n\tnetmask "$3"\n\tnetwork "$4"\n\tgateway" $5 > "$1" || echo "Error: introdueix les dades correctament, 6 parametres per a executar el script (adressa fitxer, adressa ip, netmask, network, gateway i network interface) o 1 parametre (-h) per a demanar ajuda de com s'ha d'executar el fitxer"
										else
											echo "La gateway introduida no esta dintre el rang, torna a executar el script amb una gateway valida"
										fi
									else
										echo "El network introduit no esta dintre el rang, torna a executar el script amb un ntwork valid"
									fi
								else
									"La netmask introduida no esta dintre el rang, torna a executar el script amb una netmask valida"
								fi
							else
								echo "La ip introduida no esta dintre el rang de ips, torna a executar el script amb una ip valida"
							fi
						else
							echo "La gateway introduida no es valida, ha de tindre un format per exemple: 192.168.1.34"
						fi
					else
						echo "El network introduit no es valid, ha de tindre un format per exemple: 192.168.1.34"
					fi
				else
					echo "La netmask introduida no es una netmask valida ha de tindre un format com per exemple: 255.255.255.0"
				fi
			else
				echo "La ip introduida no es una ip valida ha de tindre el format per exemple: 192.168.1.34"
			fi
		else
			echo "Error: el fitxer no existeix"
		fi
	else
		echo "Has de passar 6 parametres(adressa del fitxer, adressa ip, mask, network, gateway i el network interface) o 1 parametre en cas de volguer ajuda"
	fi
else
	echo error >&2 ": Aquest script nomes pot ser executat com a root a super usuari."
	exit 1
fi
