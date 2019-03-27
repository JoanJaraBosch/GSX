#!/bin/bash


if [ "$(whoami)" != "root" ];then

	echo "Please run as root"
	exit

fi

last_backup=$(ls -t /back | head -1)	#last backupfile

tar -xvzf  "/back/$last_backup/"*".tgz"	#x:extract;v:verbose;z:gnuzip;f:for file

while read owner group permissions file; do
	if grep -q $group /etc/group ; then	#option -q does not write any output
		#echo "group, " $group ", exists"
		if  grep  -q  $owner /etc/passwd  ; then
			echo "owner, " $owner ", exists"
		else 
			echo "owner, " $owner ",  does not exist"
		fi

		if ! [ -e "$file" ] ; then
			f=${file##*/} #split and get last
			mv "$f" "$file" 2> /dev/null
			chmod $permissions "$file" 2> /dev/null
			chown $owner "$file"	2> /dev/null
			chgrp $group "$file"	2> /dev/null
		else
			echo "file, " $file " does not exist"
		fi
	else
		echo "no existeix grup, " $group
	fi

done < "permissions.txt"
