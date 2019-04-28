#!/bin/sh
#
# Demonstrates hiding echo output
#

stty -echo
echo "What is the secret?"
read SECRET
stty echo
echo $SECRET
