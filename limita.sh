#!/bin/bash

# Authors: Jose Angel Morena, Aleix Iglesias i Joan Jara
# Date: 20/02/2019
# Version: 1.0
# Description: Aquest script rep un parametre que es -h o la cpu on s'executara la bash i els seus fills,el nom de nombre de processos maxims i opcionalment l'usuari que tindra limitat els processos maxims. Si no passes un usuari, es fara per tots els usuaris. Un cop tinguem el nombre maxim de processos, el que fara sera limitar els processos maxims per usuari i que tots el processos de la bash s'executin en una sola cpu.

dir=/sys/fs/cgroup/cpuset

if [ "$#" -eq 1 ];then
	if [ "$1" == "-h" ];then
		echo "Aquest script serveix per limitar el nombre de processos per un usuari i que els processos de la bash, s'executin en una sola cpu. EL script rebra per parametre 1(-h), 2(cpu,num procesos) o 3 parametres(cpu, num processos i usuari)."
	else
		echo "Si passes nomes un parametre, ha de ser -h"	
	fi
elif [ "$#" -eq 2 ] || [ "$#" -eq 3 ];then
	numP=$(cat /proc/cpuinfo | grep cpu\ cores | awk '{print $4}')
	if ! [ "$1" -eq "$1" ] 2> /dev/null 
	then
		echo "El primer parametre ha de ser un numero (cpu)"
		exit 1
	else
		let numP=numP-1
		if [ "$1" -gt "$numP" ] || [ "$1" -lt 0 ];then
			echo "Error: has de passar una cpu no negativa i que estigui entre el rang de les teves cpu"
			exit 1
		fi	
	fi	

	if ! [ "$2" -eq "$2" ] 2> /dev/null 
	then
		echo "El segon parametre ha de ser un numero (nproc)"
		exit 1
	fi

	if [ "$#" -eq 2 ];then
		echo "* soft nproc $2" >> /etc/security/limits.conf #posem soft per si posen pocs processos nproc
	else
		echo "$3 soft nproc $2" >> /etc/security/limits.conf #posem soft per si posen pocs processos nproc
	fi
	
	mkdir -p "$dir/groupLimit"
	echo $1 > "$dir/groupLimit/cpuset.cpus"
	echo 0 > "$dir/groupLimit/cpuset.mems" #per defecte el node 0 
	echo $$ > "$dir/groupLimit/tasks"
else
	echo "Error, no has passat el nombre de parametres correctes. EL script rebra per parametre 1(-h), 2(cpu,num procesos) o 3 parametres(cpu, num processos i usuari)."
fi
