#!/bin/bash

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Starting 4_Install_vDCM.sh >> /tmp/install.log

/tmp/vdcm-installer-18.0.9-177.sh --non-interactive --set-interface-mgmt eno1 --set-interface-video enp94s0f0 --set-interface-video enp94s0f1 --rp-filter-disable --passphrase-policy-none --authentication-local --user-add chtradmin --user-passphrase chtradmin --user-ignore-passphrase-policy --user-iiop-admin --user-rest-user --user-gui-admin --user-add systems --user-passphrase Ch@rt3r!5 --user-ignore-passphrase-policy --user-iiop-admin --user-rest-user --user-gui-admin --firewall-use-vdcm-zones --firewall-enable --ntp-add-server 172.27.0.4

vdcm-configure check
/opt/vdcm/bin/vdcm-configure service -d --now --local-
service ntpd stop
ntpdate 10.253.1.1
ntpdate 10.253.1.1
ntpdate 10.253.1.1
service ntpd start

firewall-cmd --zone=vdcm_mgmt --permanent --change-interface=eno1
firewall-cmd --permanent --zone=vdcm_mgmt --set-target=DROP
firewall-cmd --permanent --zone=vdcm_video --set-target=DROP
firewall-cmd --zone=vdcm_video --permanent --change-interface=enp94s0f0
firewall-cmd --get-active-zones

firewall-cmd --zone=vdcm_mgmt --add-port=22/tcp --permanent
firewall-cmd --zone=vdcm_mgmt --add-port=123/tcp --permanent
firewall-cmd --zone=vdcm_mgmt --add-port=443/tcp --permanent
firewall-cmd --zone=vdcm_mgmt --add-port=1500/tcp --permanent
firewall-cmd --zone=vdcm_mgmt --add-port=3000/tcp --permanent
firewall-cmd --zone=vdcm_mgmt --add-port=5003/tcp --permanent
firewall-cmd --zone=vdcm_mgmt --add-port=8443/tcp --permanent

firewall-cmd --zone=vdcm_mgmt --permanent --add-service=grafana --add-service=http --add-service=https --add-service=influxdb --add-service=ntp --add-service=snmp --add-service=ssh --add-service=vdcm-abr2ts --add-service=vdcm-bb-inp-processing-debug --add-service=vdcm-bb-inp-processing-mgmt --add-service=vdcm-esam --add-service=vdcm-iiop --add-service=vdcm-mfp-control-debug --add-service=vdcm-mfp-control-video --add-service=vdcm-mfp-processing-debug --add-service=vdcm-mfp-processing-mgmt --add-service=vdcm-mfp-processing-video --add-service=vdcm-rest --add-service=vdcm-scte-30 --add-service=vdcm-secure-iiop --add-service=vdcm-smi-debug --add-service=vdcm-splicer-video --add-service=vdcm-urc-statmux-client --add-service=vdcm-urc-statmux-controller --add-service=vdcm-xgress-mgmt --add-service=vdsm
firewall-cmd --zone=vdcm_video --permanent --add-service=vdcm-mfp-control-video --add-service=vdcm-urc-statmux-client --add-service=vdcm-urc-statmux-controller

firewall-cmd --zone=vdcm_mgmt --add-protocol=icmp --permanent
firewall-cmd --zone=vdcm_video --add-protocol=icmp --permanent

firewall-cmd --runtime-to-permanent
firewall-cmd –reload

firewall-cmd --zone=vdcm_mgmt --list-all

firewall-cmd --zone=vdcm_video --list-all

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Finished 4_Install_vDCM.sh >> /tmp/install.log

#reboot