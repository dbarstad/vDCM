#!/bin/bash
# /netboot/www/Charter/vDCM_Install.sh

sleep 15

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == vDCM_Install - Starting vDCM_Install.sh >> /tmp/install.log
echo $dt == vDCM_Install - Starting vDCM_Install.sh

echo $dt == vDCM_Install - Reoving vDCM_Install.sh from startup >> /tmp/install.log
echo $dt == vDCM_Install - Reoving vDCM_Install.sh from startup

Systemctl disable vDCM_Install.service
rm -f /etc/systemd/system/vDCM_Install.service

hwsn=$( cat /sys/class/dmi/id/product_serial )

echo $dt == vDCM_Install - Matching hwsn - $hwsn >> /tmp/install.log
echo $dt == vDCM_Install - Matching hwsn - $hwsn

while IFS==, read -r region hname counter cip cnm cgw mip mnm mgw inip innm ingw egip egnm eggw repo NTP1 NTP2 sn ; do

  if [[ "$hwsn" == "$sn" ]] ; then
        break
  fi

done < /tmp/sysdata.txt

if [[ "$hwsn" != "$sn" ]] ; then
    	echo $dt == vDCM_Install - Failed to match hwsn - $hwsn >> /tmp/install.log
		echo $dt == vDCM_Install - Failed to match hwsn - $hwsn
fi

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == vDCM_Install - Running vdcm install >> /tmp/install.log
echo $dt == vDCM_Install - Running vdcm install

vdcm_chtradmin_pass=`cat /tmp/vdcm_chtradmin_pass`

/tmp/vdcm-installer-20.0.4-118.sh --non-interactive --set-interface-mgmt eno1 --set-interface-video enp94s0f0 --set-interface-video enp94s0f1 --rp-filter-disable --service-enable --service-all --passphrase-policy-none --authentication-local --user-add chtradmin --user-passphrase $vdcm_chtradmin_pass --user-ignore-passphrase-policy --user-iiop-admin --user-rest-user --user-gui-admin --firewall-use-vn-zones --firewall-enable --ntp-add-server $NTP1

#Validate adding systems user **Foo**
dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Adding systems user >> /tmp/install.log
echo $dt == final - Adding systems user

# vdcm_system_pass=`cat /tmp/vdcm_system_pass`

# vdcm-configure user --add systems --passphrase $vdcm_system_pass --ignore-passphrase-policy --iiop-admin --rest-user --gui-admin

dt=`date '+%d/%m/%Y_%H:%M:%S'`
# echo $dt == vDCM_Install - Removing origin server >> /tmp/install.log
# echo $dt == vDCM_Install - Removing origin server

/opt/vdcm/bin/vdcm-configure service -d --now --local-origin-server

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == vDCM_Install - Updating NTP >> /tmp/install.log
echo $dt == vDCM_Install - Updating NTP

# Validate IP for NTP.  App set to 10.253.2.1 vs 10.253.1.1
dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == vDCM_Install - Asserting NTP host - $NTP1 >> /tmp/install.log
echo $dt == vDCM_Install - Asserting NTP host - $NTP1

service ntpd stop
ntpdate $NTP1
ntpdate $NTP1
ntpdate $NTP1
service ntpd start

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == vDCM_Install - Configuring firewall >> /tmp/install.log
echo $dt == vDCM_Install - Configuring firewall

firewall-cmd --zone=vn_mgmt --permanent --change-interface=eno1 >> /tmp/install.log
firewall-cmd --permanent --zone=vn_mgmt --set-target=DROP >> /tmp/install.log
firewall-cmd --permanent --zone=vn_video --set-target=DROP >> /tmp/install.log
firewall-cmd --zone=vn_video --permanent --change-interface=enp94s0f0 >> /tmp/install.log

firewall-cmd --zone=vn_mgmt --add-port=22/tcp --permanent >> /tmp/install.log
firewall-cmd --zone=vn_mgmt --add-port=123/tcp --permanent >> /tmp/install.log
firewall-cmd --zone=vn_mgmt --add-port=443/tcp --permanent >> /tmp/install.log
firewall-cmd --zone=vn_mgmt --add-port=1500/tcp --permanent >> /tmp/install.log
firewall-cmd --zone=vn_mgmt --add-port=3000/tcp --permanent >> /tmp/install.log
firewall-cmd --zone=vn_mgmt --add-port=5003/tcp --permanent >> /tmp/install.log
firewall-cmd --zone=vn_mgmt --add-port=8443/tcp --permanent >> /tmp/install.log

firewall-cmd --zone=vn_mgmt --permanent --add-service=grafana --add-service=http --add-service=https --add-service=influxdb --add-service=ntp --add-service=snmp --add-service=ssh --add-service=vdcm-abr2ts --add-service=vdcm-bb-inp-processing-debug --add-service=vdcm-bb-inp-processing-mgmt --add-service=vdcm-esam --add-service=vdcm-iiop --add-service=vdcm-mfp-control-debug --add-service=vdcm-mfp-control-video --add-service=vdcm-mfp-processing-debug --add-service=vdcm-mfp-processing-mgmt --add-service=vdcm-mfp-processing-video --add-service=vdcm-rest --add-service=vdcm-scte-30 --add-service=vdcm-secure-iiop --add-service=vdcm-smi-debug --add-service=vdcm-splicer-video --add-service=vdcm-urc-statmux-client --add-service=vdcm-urc-statmux-controller --add-service=vdcm-xgress-mgmt --add-service=vdsm >> /tmp/install.log
firewall-cmd --zone=vn_video --permanent --add-service=vdcm-mfp-control-video --add-service=vdcm-urc-statmux-client --add-service=vdcm-urc-statmux-controller >> /tmp/install.log

firewall-cmd --zone=vn_mgmt --add-protocol=icmp --permanent >> /tmp/install.log
firewall-cmd --zone=vn_video --add-protocol=icmp --permanent >> /tmp/install.log
firewall-cmd --zone=vn_mgmt --add-protocol=icmp --permanent >> /tmp/install.log
firewall-cmd --zone=vn_video --add-protocol=icmp --permanent >> /tmp/install.log

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == vDCM_Install - Reloading Firewall >> /tmp/install.log
echo $dt == vDCM_Install - Reloading Firewall
echo firewall-cmd --reload >> /tmp/install.log
firewall-cmd --reload >> /tmp/install.log

echo $dt == vDCM_Install - Firewall active zones >> /tmp/install.log
echo $dt == vDCM_Install - Firewall active zones
firewall-cmd --get-active-zones

echo $dt == vDCM_Install - Firewall list-all for vn_mgmt >> /tmp/install.log
echo $dt == vDCM_Install - Firewall list-all for vn_mgmt
firewall-cmd --zone=vn_mgmt --list-all  >> /tmp/install.log

echo $dt == vDCM_Install - Firewall list-all for vn_video >> /tmp/install.log
echo $dt == vDCM_Install - Firewall list-all for vn_video
firewall-cmd --zone=vn_video --list-all >> /tmp/install.log

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == vDCM_Install - Configuring Cleanup.sh to run on reboot >> /tmp/install.log
echo $dt == vDCM_Install - Configuring Cleanup.sh to run on reboot

systemctl disable vDCM_Install.service
rm -f /etc/systemd/system/vDCM_Install.service

echo [Unit] >> /etc/systemd/system/Cleanup.service
echo Description=Invoke Cleanup script  >> /etc/systemd/system/Cleanup.service
echo After=network-online.target  >> /etc/systemd/system/Cleanup.service
echo  >> /etc/systemd/system/Cleanup.service
echo [Service]  >> /etc/systemd/system/Cleanup.service
echo Type=simple  >> /etc/systemd/system/Cleanup.service
echo ExecStart=/tmp/Cleanup.sh  >> /etc/systemd/system/Cleanup.service
echo TimeoutStartSec=0  >> /etc/systemd/system/Cleanup.service
echo  >> /etc/systemd/system/Cleanup.service
echo [Install]  >> /etc/systemd/system/Cleanup.service
echo WantedBy=default.target  >> /etc/systemd/system/Cleanup.service

systemctl daemon-reload
systemctl enable Cleanup.service

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == vDCM_Install - Finished vDCM_Install.sh >> /tmp/install.log
echo $dt == vDCM_Install - Finished vDCM_Install.sh

reboot
