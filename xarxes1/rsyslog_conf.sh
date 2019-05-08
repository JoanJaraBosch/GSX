#!/bin/bash
#Aquet script nomes rep dos parametres:

echo "----------------------------------------------------------------------------------------------------------------"
echo "ESTEM APLICANT RSYSLOG"
echo "Vols ser client o server del rsyslog(si no vols fer res posa N)? (client/server/N)"

read rol

if [ $rol = "server" ];then
cp -p /etc/rsyslog.conf ~/
cp -p ./rsyslog.conf  /etc/rsyslog.conf
echo '$template GuardaRemots, "/var/log/remots/%HOSTNAME%/%timegenerated:1:10:date-rfc3339%"' > /etc/rsyslog.d/10-remot.conf
echo ':source, !isequal, "localhost" -?GuardaRemots' >> /etc/rsyslog.d/10-remot.conf
echo "/var/log/syslog {/ndaily/ncopytruncate/nrotate 180/ncompress/nmissingok/n}" > /etc/logrotate.d/remots
service rsyslog restart
elif [ $rol = "client" ];then
echo "Quina ip te el servidor?"
read ip
echo "*.*   @$ip:514" > /etc/rsyslog.d/90-remot.conf
service rsyslog restart
elif [ $rol = "N" ];then
echo "Has escollit no actuar ni activar el rsyslog"
else
echo "Rol escollit incorrectament"
fi
