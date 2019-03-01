#!/bin/bash

mkdir -p /back
directoris=$(ls /back)
dataDir=$(date +"%y%m%d")
for directori in "$directoris";do
	if [ ${#directori} -gt 4 ];then
		nom=${directori:0:6}
		if [ "$dataDir" = "$nom" ];then 
			echo "Error: Ja s'ha fet la copia de seguretat avui"
			exit 1
		fi
	fi
done
dataDir=$(date +"%y%m%d%H%M")
mkdir -p /back/$dataDir

arrancada=$(who -r | tr - " " | awk '{ print substr($4,3,2)$5$6}') 
arrancada=$(date --date=$arrancada +%s)
avui=$(date +%s)
dies=$((($avui - $arrancada) / (60*60*24*7)))
fitxers=$(find / -type f -mtime "$dies" 2>/dev/null)
IFS=$'\n'
for file in $fitxers
do
	echo "$file" >> /back/"$dataDir"/gpInformation.txt
done
unset IFS
cd /back/$dataDir/
/usr/bin/gpgp.sh gpInformation.txt > /dev/null
readlink -f $(ls) >> gpInformation.txt
tar -cvf "$dataDir.tgz" -T gpInformation.txt
rm /back/"$dataDir"/*.txt
