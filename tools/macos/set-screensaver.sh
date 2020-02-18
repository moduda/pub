#!/bin/sh
#
# Set up screensaver
#

# Deposit photo file in here
FOLDERPATH="/Users/Shared/screensaver"
# Idle time in seconds
IDLETIME=7200
# Display clock true/false
SHOWCLOCK=true

## Set Screensaver to Photo Slideshow
/usr/bin/defaults -currentHost write com.apple.screensaver 'CleanExit' -string "YES"
/usr/bin/defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "path" -string "/System/Library/Frameworks/ScreenSaver.framework/Resources/iLifeSlideshows.saver"
/usr/bin/defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "type" -int "0" 
/usr/bin/defaults -currentHost write com.apple.screensaver 'ShowClock' -bool "$SHOWCLOCK"
/usr/bin/defaults -currentHost write com.apple.screensaver 'tokenRemovalAction' -int "0"

## Set Type of Slideshow to "Flipup" (Results inconsistent)
/usr/bin/defaults -currentHost write com.apple.ScreenSaver.iLifeSlideshows 'styleKey' -string "Floating" 

## Set location of photos to Fan Art 
/usr/bin/defaults -currentHost write com.apple.ScreenSaverPhotoChooser 'SelectedSource' -int "4"
/usr/bin/defaults -currentHost write com.apple.ScreenSaverPhotoChooser 'SelectedFolderPath' "$FOLDERPATH"
/usr/bin/defaults -currentHost write com.apple.ScreenSaverPhotoChooser 'ShufflesPhotos' -bool "true"
/usr/bin/defaults -currentHost write com.apple.screensaver idleTime $IDLETIME

killall cfprefsd
