#!/bin/bash
#
# Demonstrates a file check
# 

FILE=$1

if [ -e $FILE ]
	then
	  if [ -s $FILE ]
		then
		  	echo "Contents of file: "
			cat $FILE
			exit
		else
			echo "File exists but contains no data"
			exit
     fi
else
	echo "File does not exist"
fi