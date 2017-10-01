#!/bin/bash

FILE="/Users/jason4151/foo.txt"

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