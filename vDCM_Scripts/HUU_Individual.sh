#!/bin/bash

if [[ "$1" == "" ]] | [[ "$2" == "" ]]; then
  echo "Usage: HUU_Individual.sh <target IP> <PXE server IP>"
  exit
fi

python2 update_firmware-4.1.2b.py -a $1 -u admin -p password -m ucs-c220m5-huu-4.1.1d.iso -i $2 -d /Charter/ -t www -r root -w Trace3Lab2020! -y all
