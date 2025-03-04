#!/bin/bash
#
# Add a host to Cobbler the easy way
#

if [ $# -eq 0 ]; then
  echo "Usage: $0 FQDN IP NETMASK GATEWAY MAC"
else
cat << PROFILE
Which profile should be assigned to this host?

1.) rhel-server-6.4-x86_64
2.) rhel-workstation-6.4-x86_64

PROFILE
  echo -n "Profile: "
  read ANSWER

    if [ ${ANSWER} -eq 1 ]; then
      PROFILE='rhel-server-6.4-x86_64'
    else
      PROFILE='rhel-workstation-6.4-x86_64'
    fi

  FQDN=$1
  IP=$2
  NETMASK=$4
  MAC=$5
  HOST=`echo ${FQDN} | cut -d '.' -f1`

  echo -e "\nAdding ${FQDN} to Cobbler\n"
cat EOF <<
Hostname: $FQDN
IP Addr:  $IP
Netmask:  $NETMASK
Gateway:  $GATEWAY
MAC:      $MAC
Profile:  $PROFILE
EOF

  sudo /usr/bin/cobbler system report --name=${HOST} > /dev/null
  
  if [ $? -eq 0 ]; then
    echo -e "\nError: System is already in Cobbler"
    exit 1
  else
    sudo /usr/bin/cobbler system add --name=${HOST} --profile=${PROFILE} --hostname=${FQDN} --interface=eth0 --mac-address=${MAC} --static=yes --management=yes --ip-address=${IP} --gateway=${GATEWAY} --netmask=${NETMASK}
    sudo /usr/bin/cobbler system report --name=${HOST} > /dev/null
    
    if [ $? -eq 1 ]; then
      echo -e "\nError: System was not added to Cobbler"
      exit 1
    else
      echo -e "\n${FQDN} successfully added to Cobbler"
      exit 0
  fi