#!/bin/sh
#
# Change file names to lowercase and replace spaces with an underscore. 
#

find . -name '*' -print |
while read OLDNAME
  do
    NEWNAME=`echo $OLDNAME | tr ' ' '_' | tr '[A-Z]' '[a-z]'`
    if [ "$OLDNAME" != "$NEWNAME" ]; then
      mv "$OLDNAME" "$NEWNAME"
    fi
  done
