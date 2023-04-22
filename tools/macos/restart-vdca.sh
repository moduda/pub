#! /bin/sh
#
# From: https://mackeeper.com/blog/post/how-to-fix-mac-camera/
# To reset a Mac camera, you need to disable the daemon responsible
# for the build-in camera on  a MacBook. This can be done via Terminal,
# type in sudo killall VDCAssistant and press Enter. This will restart
# the daemon and all apps using the camera.
#
# 12.oct.20	ykim
#
sudo killall VDCAssistant
