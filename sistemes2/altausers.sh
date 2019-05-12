#!/bin/bash

# Authors: Grup1A
# Version: 1.0
# Date: 25/04/2019
# Description: Script que recibe un fichero por parametro y lee linea a linea cogiendo los datos de cada usuario (porque cada usuario és una linea)
# Y entonces lo añade al sistema.

if [ "$(whoami)" != "root" ];then #$EUID o id -u son otras opciones (effective uid)
	echo "no ets root!"
	exit 1
fi
if ! [ $# -ge 1 ];then
echo “No has pasat un fitxer”
exit 1
fi

filename=$1
IFS=$'\n'
for line in $(cat $filename) ; do
	IFS=' '
	read -ra arr <<< "$line"
	dni="${arr[0]}"
	name="${arr[1]}"
	cognom1="${arr[2]}"
	cognom2="${arr[3]}"
	password="${arr[4]}"
	primary_group="${arr[5]}"
	for grup in "${arr[@]:6}"; do	# a partir del sise camp...
		secundary_groups="$secundary_groups""$grup"","
	done
	groups=${secundary_groups::-1}	#treure ultima coma
	c1="$(echo $cognom1 | head -c 1)"	#coger primer caracter
	c2="$(echo $cognom2 | head -c 1)"	#coger segundo caracter
	user=$name$c1$c2
	user=${user,,}	#convertir en minuscula
	if grep -q "$user" /etc/passwd; then	#ya existe usuario...
		i=0
		num_users=$(echo "$(cat /etc/passwd | wc -l)")	#numero de usuaris
		while [ $i -lt $num_users ]; do
			((i++))
			new_user="${user}"$i
			if ! grep -q "$new_user" /etc/passwd; then	#si aquest usuari no existeix sortim del bucle i el creem
				user="$new_user"
				break
			fi
		done
	fi

	if [ $# -gt 1 ]; then
		mv $2 /root/conf/.usuaris
	fi	
	if [ -e /root/conf/.usuaris ]; then
		adduser --disabled-password --conf /root/conf/.usuaris --gecos ""  $user
		echo "$user:$password" | chpasswd	#Assing password
		usermod -g $primary_group $user
		usermod -a -G $groups $user
	fi
done
exit 0
