#!/bin/bash
#
# macOS maintenance (deprecated)
#

echo "Running all periodic maintenance scripts."
sudo periodic daily weekly monthly

echo "Cleaning up font cache."
sudo atsutil databases -remove

echo "Updating locate database."
sudo /usr/libexec/locate.updatedb

echo "Cleaning up user caches and logs."
sudo rm -rf ~/Library/{Caches,Logs}/*

echo "Flushing DNS Cache"
sudo killall -HUP mDNSResponder

echo "Reseting Launchpad"
defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock


