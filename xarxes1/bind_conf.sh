#!/bin/bash

echo "-------------------------------------------------------------"
echo "ESTEM APLICANT EL DNS"

echo "Ets el router?(Y/N)"
read answer

if [ $answer = "Y" ];then

apt-get install bind9



fi
