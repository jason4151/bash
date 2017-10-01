#!/bin/sh
stty -echo
echo "What is the password?"
read PASSWORD
stty echo
echo $PASSWORD
