#!/bin/bash

if [ $(id -u) = 0 ];then

./dhcp_conf.sh

./rsyslog_conf.sh

./iptables_ssh.sh

else

echo "Has de ser super usuari"

fi
