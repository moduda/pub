#! /bin/sh
#

sudo apt update
sudo apt dist-upgrade
pihole -v
read -p "Start upgrade (y/n)? " reply
case $reply in
[Yy]*)		;;
*)		echo "Aborting."; exit ;;
esac
pihole -up
echo -------------- done ----------------
pihole -v
