#!/bin/bash
echo "Running all periodic maintenance scripts..."
sudo periodic daily weekly monthly
echo -e "done\n"

echo "Cleaning up font cache..."
sudo atsutil databases -remove
echo -e "done\n"

echo "Updating locate database..."
sudo /usr/libexec/locate.updatedb
echo -e "done\n"

echo "Cleaning up user caches..."
sudo rm -rf ~/Library/Caches/*
echo -e "done\n"

echo "Cleaning up user logs..."
sudo rm -rf ~/Library/Logs/*
echo -e "done\n"
