#!/bin/bash

echo "-------------------------------------------------------------"
echo "ESTEM APLICANT EL DNS"

echo "Ets el router?(Y/N)"
read answer

if [ $answer = "Y" ];then

apt-get install bind9
apt-get install bind9-doc
apt-get install dnsutils

echo -e 'include "/etc/bind/named.conf.options";\ninclude "/etc/bind/named.conf.local";' > /etc/bind/named.conf

echo -e 'view "Lab1A.int"{\n\tmatch-clients{172.22.2.0/24;198.18.22.0/28;localhost;};\n\trecursion yes;\n\tzone "grup1A.int" {\n\t\ttype master;\n\t\tfile "/etc/bind/db.grup1A.int";\n\t};\n\n\tzone "2.22.172.in-addr.arpa" {\n\t\ttype master;\n\t\tfile "/etc/bind/db.172";\n\t\tnotify no;\n\t};\n\n\tzone "grup1A.dmz" {\n\t\ttype master;\n\t\tfile "/etc/bind/db.grup1A.dmz";\n\t};\n\n\tzone "22.18.198.in-addr.arpa" {\n\t\ttype master;\n\t\tfile "/etc/bind/db.198";\n\t\tnotify no;\n\t};\n\tinclude "/etc/bind/named.conf.default-zones";\n};\n\nview "Lab1A.ext"{\n\tmatch-clients{any;};\n\trecursion yes;\n\tzone "grup1A.ext" {\n\t\ttype master;\n\t\tfile "/etc/bind/db.grup1A.ext";\n\t};\n\n\tzone "10.in-addr-arpa" {\n\t\ttype master;\n\t\tfile "/etc/bind/db.ext.rev";\n\t\tnotify no;\n\t};\n};' > /etc/bind/named.conf.local

echo -e 'options {\n\tdirectory "/var/cache/bind";\n\tallow-recursion { 198.18.22.0/28; };\n\tallow-recursion-on { 198.18.22.0/28; };\n\tforwarders {\n\t\t10.45.1.2;\n\t\t10.40.1.2;\n\t\t10.40.1.108;\n\t};\n\n\tauth-nxdomain no;\n};' > /etc/bind/named.conf.options

echo -e '; file "db.grup1A.int";\n$TTL    604800\n@       IN      SOA     ns.grup1A.int.  root.grup1A.int.   (\n\t1       ; Serial\n\t604800       ; Refresh\n\t86400       ; Retry\n\t2419200       ; Expire\n\t604800 )     ; Negative Cache TTL\n;\n@       IN      NS      ns\nns      IN      A       172.22.2.1\n\nrouter      IN    A   172.22.2.1\ncorreu      IN    A   172.22.2.1\ndhcp        IN    A   172.22.2.1\nadmin       IN    A   172.22.2.2\nwww         IN    A   172.22.2.3\n\nPC100 IN A 172.22.2.100\nPC101 IN A 172.22.2.101\nPC102 IN A 172.22.2.102\nPC103 IN A 172.22.2.103\nPC104 IN A 172.22.2.104\nPC105 IN A 172.22.2.105\nPC106 IN A 172.22.2.106\nPC107 IN A 172.22.2.107\nPC108 IN A 172.22.2.108\nPC109 IN A 172.22.2.109\nPC110 IN A 172.22.2.110\nPC111 IN A 172.22.2.111\nPC112 IN A 172.22.2.112\nPC113 IN A 172.22.2.113\nPC114 IN A 172.22.2.114\nPC115 IN A 172.22.2.115\nPC116 IN A 172.22.2.116\nPC117 IN A 172.22.2.117\n' > /etc/bind/db.grup1A.int

echo -e '; file "db.grup1A.dmz";\n$TTL    604800\n@       IN      SOA     ns.grup1A.dmz.  root.grup1A.dmz.   (\n\t1      ; Serial\n\t604800       ; Refresh\n\t86400       ; Retry\n\t2419200       ; Expire\n\t604800 )     ; Negative Cache TTL\n;\n@       IN      NS      ns\nns      IN      A       198.18.22.1\n\nrouter      IN    A   198.18.22.1\ncorreu      IN    A   198.18.22.1\ndhcp        IN    A   198.18.22.1\nadmin       IN    A   198.18.22.2\nwww         IN    A   198.18.22.3\n' > /etc/bind/db.grup1A.dmz

echo -e '; file "db.198";\n$TTL    604800\n@       IN      SOA     ns.grup1A.dmz.   root.grup1A.dmz.     (\n\t1       ; Serial\n\t604800       ; Refresh\n\t86400       ; Retry\n\t2419200       ; Expire\n\t604800 )     ; Negative Cache TTL\n\t;\n@       IN      NS      ns.grup1A.dmz.\n\n1       IN      PTR     ns.grup1A.dmz.\n\n1	IN	PTR	correu.grup1A.dmz.\n1	IN	PTR	router.grup1A.dmz.\n1	IN	PTR	dhcp.grup1A.dmz.\n2	IN	PTR	admin.grup1A.dmz.\n3	IN	PTR	www.grup1A.dmz.\n' > /etc/bind/db.198

echo -e '; file "db.172";\n$TTL    604800\n@       IN      SOA     ns.grup1A.int.   root.grup1A.int.     (\n\t1       ; Serial\n\t604800       ; Refresh\n\t86400       ; Retry\n\t2419200       ; Expire\n\t604800 )     ; Negative Cache TTL\n;\n@       IN      NS      ns.grup1A.int.\n1       IN      PTR     ns.grup1A.int.\n\n1	IN	PTR	correu.grup1A.int.\n1	IN	PTR	router.grup1A.int.\n1	IN	PTR	dhcp.grup1A.int.\n2	IN	PTR	admin.grup1A.int.\n3	IN	PTR	www.grup1A.int.\n\n100	IN	PTR	PC100.grup1A.int.\n101	IN	PTR	PC101.grup1A.int.\n102	IN	PTR	PC102.grup1A.int.\n103	IN	PTR	PC103.grup1A.int.\n104	IN	PTR	PC104.grup1A.int.\n105	IN	PTR	PC105.grup1A.int.\n106	IN	PTR	PC106.grup1A.int.\n107	IN	PTR	PC107.grup1A.int.\n108	IN	PTR	PC108.grup1A.int.\n109	IN	PTR	PC109.grup1A.int.\n110	IN	PTR	PC110.grup1A.int.\n111	IN	PTR	PC111.grup1A.int.\n112	IN	PTR	PC112.grup1A.int.\n113	IN	PTR	PC113.grup1A.int.\n114	IN	PTR	PC114.grup1A.int.\n115	IN	PTR	PC115.grup1A.int.\n116	IN	PTR	PC116.grup1A.int.\n117	IN	PTR	PC117.grup1A.int.\n' > /etc/bind/db.172

echo -e 'nameserver 127.0.01\nnameserver 172.22.2.2\nnameserver 198.18.22.2\nnameserver 10.45.1.2\nnameserver 193.144.16.4' > /etc/resolv.conf

echo -e '; file "db.grup1A.ext";\n$TTL	604800\n@	IN	SOA	ns.grup1A.ext.   root.grup1A.ext.	(\n\t1	; Serial\n\t604800	; Refresh\n\t86400	; Retry\n\t2419200	; Expire\n\t604800 )	; Negative Cache TTL\n;\n@	IN	NS	ns\nns	IN	A	10.21.1.17\n\nwww.grup1A.gsx	IN	A	10.21.1.17' > /etc/bind/db.grup1A.ext

echo -e '; file "db.ext.rev";\n$TTL    604800\n@       IN      SOA     ns.grup1A.ext.   root.grup1A.ext.     (\n\t1       ; Serial\n\t604800       ; Refresh\n\t86400       ; Retry\n\t2419200       ; Expire\n\t604800 )     ; Negative Cache TTL\n\t;\n@       IN      NS      ns.grup1A.ext.\n\n1       IN      PTR     ns.grup1A.ext.\n\n17.1	IN	PTR	correu.grup1A.ext.\n17.1	IN	PTR	www.grup1A.gsx.\n' > /etc/bind/db.ext.rev

systemctl restart bind9

fi
