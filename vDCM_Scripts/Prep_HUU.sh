#!/bin/bash

while IFS==, read -r data_time action ip mac_addr ; do

  echo Checking $ip - action - $action
  
  if [[ "$action" == "add" ]] ; then
  	echo address=$ip, user=Admin, password=$ImpPass, imagefile=ucs-c220m5-huu-4.1.1d.iso >> /netboot/vDCM_Scripts/multiserver_config
  fi

done < /netboot/vDCM_Scripts/dnsmasq.leases
