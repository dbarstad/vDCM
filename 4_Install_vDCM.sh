#!/bin/bash

sleep 30

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Starting 4_Install_vDCM.sh >> /tmp/install.log
echo $dt == 4_Install_vDCM - Starting 4_Install_vDCM.sh

hwsn=$( cat /sys/class/dmi/id/product_serial )

echo $dt == 4_Install_vDCM - Matching hwsn - $hwsn >> /tmp/install.log
echo $dt == 4_Install_vDCM - Matching hwsn - $hwsn

while IFS==, read -r sn hname dom mip mgw mnm DNS1 DNS2 hbip hbgw hbnm inip ingw innm egip eggw egnm repo NTP1 NTP2 ; do

  if [[ "$hwsn" == "$sn" ]] ; then
        break
  fi

done < /tmp/sysdata.txt

if [[ "$hwsn" != "$sn" ]] ; then
    	echo $dt == 4_Install_vDCM - Failed to match hwsn - $hwsn >> /tmp/install.log
		echo $dt == 4_Install_vDCM - Failed to match hwsn - $hwsn
fi

# dt=`date '+%d/%m/%Y_%H:%M:%S'`
# echo $dt == 4_Install_vDCM - Remounting ISO for Yum repo access >> /tmp/install.log

# Remount 
# mount -o loop /tmp/CentOS7_Q2_2020.iso /mnt-tmp
# mv -i /etc/yum.repos.d/CentOS* /etc/yum.repos.d/Saved/
# yum clean all	

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Running vdcm install >> /tmp/install.log
echo $dt == 4_Install_vDCM - Running vdcm install

/tmp/vdcm-installer-18.0.9-177.sh --non-interactive --set-interface-mgmt eno1 --set-interface-video enp94s0f0 --set-interface-video enp94s0f1 --rp-filter-disable --passphrase-policy-none --authentication-local --user-add chtradmin --user-passphrase chtradmin --user-ignore-passphrase-policy --user-iiop-admin --user-rest-user --user-gui-admin --firewall-use-vdcm-zones --firewall-enable --ntp-add-server $NTP1
# --user-add systems --user-passphrase Ch@rt3r!5 --user-ignore-passphrase-policy --user-iiop-admin --user-rest-user --user-gui-admin

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Running vdcm-configure check >> /tmp/install.log
echo $dt == 4_Install_vDCM - Running vdcm-configure check

vdcm-configure check

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Removing origin server >> /tmp/install.log
echo $dt == 4_Install_vDCM - Removing origin server

/opt/vdcm/bin/vdcm-configure service -d --now --local-origin-server

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Updating NTP >> /tmp/install.log
echo $dt == 4_Install_vDCM - Updating NTP

# Validate IP for NTP.  App set to 10.253.2.1 vs 10.253.1.1
service ntpd stop
ntpdate $NTP1
ntpdate $NTP1
ntpdate $NTP1
service ntpd start

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Configuring firewall >> /tmp/install.log
echo $dt == 4_Install_vDCM - Configuring firewall

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
firewall-cmd --reload

echo $dt == 4_Install_vDCM - Firewall list-all for vdcm_mgmt >> /tmp/install.log
echo $dt == 4_Install_vDCM - Firewall list-all for vdcm_mgmt
firewall-cmd --zone=vdcm_mgmt --list-all

echo $dt == 4_Install_vDCM - Firewall list-all for vdcm_video >> /tmp/install.log
echo $dt == 4_Install_vDCM - Firewall list-all for vdcm_video
firewall-cmd --zone=vdcm_video --list-all

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Running install cleanup >> /tmp/install.log
echo $dt == 4_Install_vDCM - Running install cleanup

# Clear PXE from boot order
/tmp/ucscfg bootorder set /tmp/boot_order_final.txt


dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Finished 4_Install_vDCM.sh >> /tmp/install.log
echo $dt == 4_Install_vDCM - Finished 4_Install_vDCM.sh

#reboot