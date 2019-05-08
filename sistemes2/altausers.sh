#!/bin/bash
if [ "$(whoami)" != "root" ];then #$EUID o id -u son otras opciones (effective uid)
	echo "no ets root!"
	exit 1
fi
name="$1"
cognom1="$2"
cognom2="$3"
c1="$(echo $cognom1 | head -c 1)"
c2="$(echo $cognom2 | head -c 1)"
user=$name$c1$c2
#otra opcion -q es silent; otra posibilidad: id "$1" > /dev/null 2>&1; then
if grep -q "$user" /etc/passwd; then	#ya existe usuario...	
	user="${user}1"	#habria que hacer bucle comprobando si exite y incrementando!
	echo "$(cat /etc/passwd | wc -l)"	#numero de usuaris
	echo "user renamed as "$user
fi

adduser $user --conf /root/conf/.usuaris

exit 0
