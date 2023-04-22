#! /bin/sh
#
# Remove a couple of config files
# Reboot system afterwards
#
# 30.oct.20	ykim
#

sudo pkill bluetoothd

sudo rm -f /Library/Preferences/com.apple.Bluetooth.plist
rm -f  ~/Library/Preferences/ByHost/com.apple.Bluetooth.*
