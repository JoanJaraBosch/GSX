#! /bin/bash

# Authors: Grup1A
# Version: 1.0
# Date: 12/05/2019
# Description: script que nomes podra executar el usuari root ja que toquem el fitxer shadow per tal de veure els usuaris. Per altra banda el fitxer creat amb contrasneyes per a la impresora sera valid per tothom ja que donem permisos de lectura per a tothom. COm és un script que hem fet opcional no posem la opcio -h dajuda ja que ja la tindra el script/comanda lp que farem nosaltres

found="0"
if ! [ -e /usr/local/ ];then
mkdir -p /usr/local/
fi

if ! [ -e /usr/local/secret ];then
touch /usr/local/secret
chmod 744 /usr/local/secret
fi

echo "Usuari que vols afegir?"
read usuari

IFS=$'\n'
for usr in $(cat /etc/shadow); do
if [ "$usuari" = $(echo $usr |cut -d ':' -f 1) ]; then
echo "he entrat"
found="1"
fi
done

if [ "$found" = "1" ];then 
echo "Usuari no trobat"
exit 1
fi

IFS=$'\n'
for usr in $(cat /usr/local/secret); do
if [ "$usuari" = $(echo $usr |cut -d ' ' -f 1) ]; then
 echo "Aquest usuari ja esta agregat amb una contrasenya"
 exit 1
fi
done

echo "Contrasenya?"
stty -echo
read password
stty echo
contra=$(openssl passwd -crypt -salt grup1A $password)

echo "$usuari $contra" >> /usr/local/secret

exit 0
