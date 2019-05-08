#!/bin/bash


usuari=$(whoami)
if [ -e /home/$usuari/tmpusr ]; then
rm -r /home/$usuari/tmpusr
unlink /home/$usuari/tmpusr
fi
umount --force /mnt/tmpusr
