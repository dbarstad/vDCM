#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: single_huu.sh <target CIMC IP> <PXE Host IP> <PXE Host Login> <PXE login password>"
else
    python2 update_firmware-4.1.2b.py -a $1 -u admin -p Ch@rt3r! -m ucs-c220m5-huu-4.1.1d.iso -i $2 -d /Charter/ -t www -r $3 -w $4 -y all
fi
