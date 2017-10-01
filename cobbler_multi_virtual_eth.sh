#!/bin/bash
#
# Adds multiple virutal interfaces to a system in cobbler
#
# Jason A. Moskowitz

if [ $# -eq 0 ]; then
  echo "Usage: $0 HOSTNAME FILE MAC"
else
  HOST=$1
  FILE=$2
  MAC=$3
  COUNT=0

  cat ${FILE} |
  while read IP
    do
      echo "Adding ${HOST}: eth0:${COUNT}: ${IP}"
      sudo /usr/bin/cobbler system edit --name=${HOST} --interface=eth0:${COUNT} --mac-address=${MAC} --static=yes --ip-address=${IP} --netmask=${NETMASK}
      let COUNT=COUNT+1
    done
fi
