#!/bin/bash

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Starting 4_Install_vDCM.sh >> /tmp/install.log

./vdcm-installer-18.0.9-177.sh --non-interactive --set-interface-mgmt eno1 --set-interface-video enp94s0f0 --set-interface-video enp94s0f1 --rp-filter-disable --passphrase-policy-none --authentication-local --user-add chtradmin --user-passphrase chtradmin --user-ignore-passphrase-policy --user-iiop-admin --user-rest-user --user-gui-admin --user-add systems --user-passphrase Ch@rt3r!5 --user-ignore-passphrase-policy --user-iiop-admin --user-rest-user --user-gui-admin --firewall-use-vdcm-zones --firewall-enable --ntp-add-server 172.27.0.4

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Finished 4_Install_vDCM.sh >> /tmp/install.log