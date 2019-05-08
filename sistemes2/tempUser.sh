#!/bin/bash
mount /mnt/tmpusr
usuari=$(whoami)
if [ -e /home/$usuari/tmpusr ]; then
unlink /home/$usuari/tmpusr
fi
ln -s /mnt/tmpusr /home/$usuari/tmpusr

