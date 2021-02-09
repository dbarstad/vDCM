#!/bin/bash

op="${1:-op}"
mac="${2:-mac}"
ip="${3:-ip}"
hostname="${4}"

tstamp="`date '+%Y-%m-%d %H:%M:%S'`"

sed -i "/$ip/d" /netboot/vDCM_Scripts/dnsmasq.leases

if [[ "$op" == "add" ]]; then
	echo $tstamp,$op,$ip,$mac,$hostname >> /netboot/vDCM_Scripts/dnsmasq.leases
fi

