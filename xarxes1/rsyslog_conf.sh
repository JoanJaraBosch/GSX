#!/bin/bash

#Aquet script nomes rep dos parametres:
# $1 = client o server
# $2 = ip del server

if [ $1 = "server" ];then
cp -p /etc/rsyslog.conf ~/
cp -p ./rsyslog.conf  /etc/rsyslog.conf
cp -p /etc/rsyslog.d/10-remot.conf ~/
cp -p ./ 10-remot.conf /etc/rsyslog.d/10-remot.conf
cp -p  /etc/logrotate.d/remots ~/
cp -p ./remots  /etc/logrotate.d/remots
service rsyslog restart
elif [ $1 = "client" ];then
echo "*.*   @$2:514" > ./90-remot.conf
cp -p /etc/rsyslog.d/90-remot.conf ~/
cp ./90-remot.conf /etc/rsyslog.d/90-remot.conf
service rsyslog restart
fi