#!/bin/bash
# /netboot/www/Charter/4_Install_vDCM.sh

sleep 30

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Starting 4_Install_vDCM.sh >> /tmp/install.log
echo $dt == 4_Install_vDCM - Starting 4_Install_vDCM.sh

echo $dt == 4_Install_vDCM - Reoving 4_Install_vDCM.sh from startup >> /tmp/install.log
echo $dt == 4_Install_vDCM - Reoving 4_Install_vDCM.sh from startup

Systemctl disable 4_Install_vDCM.service
rm -f /etc/systemd/system/4_Install_vDCM.service

hwsn=$( cat /sys/class/dmi/id/product_serial )

echo $dt == 4_Install_vDCM - Matching hwsn - $hwsn >> /tmp/install.log
echo $dt == 4_Install_vDCM - Matching hwsn - $hwsn

while IFS==, read -r region hname counter cip cgw cnm mip mgw mnm inip ingw innm egip eggw egnm repo NTP1 NTP2 sn ; do

  if [[ "$hwsn" == "$sn" ]] ; then
        break
  fi

done < /tmp/sysdata.txt

if [[ "$hwsn" != "$sn" ]] ; then
    	echo $dt == 4_Install_vDCM - Failed to match hwsn - $hwsn >> /tmp/install.log
		echo $dt == 4_Install_vDCM - Failed to match hwsn - $hwsn
fi

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Running vdcm install >> /tmp/install.log
echo $dt == 4_Install_vDCM - Running vdcm install

/tmp/vdcm-installer-18.0.9-177.sh --non-interactive --set-interface-mgmt eno1 --set-interface-video enp94s0f0 --set-interface-video enp94s0f1 --rp-filter-disable --passphrase-policy-none --authentication-local --user-add chtradmin --user-passphrase chtradmin --user-ignore-passphrase-policy --user-iiop-admin --user-rest-user --user-gui-admin --firewall-use-vdcm-zones --firewall-enable --ntp-add-server $NTP1

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Adding systems user >> /tmp/install.log
echo $dt == final - Adding systems user

vdcm-configure user --add systems --passphrase "Ch@rt3r!5" --ignore-passphrase-policy --iiop-admin --rest-user --gui-admin

dt=`date '+%d/%m/%Y_%H:%M:%S'`
# echo $dt == 4_Install_vDCM - Removing origin server >> /tmp/install.log
# echo $dt == 4_Install_vDCM - Removing origin server

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

echo sudo firewall-cmd --zone=vdcm_mgmt --permanent --change-interface=eno1  >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --permanent --change-interface=eno1  >> /tmp/install.log
echo sudo firewall-cmd --permanent --zone=vdcm_mgmt --set-target=DROP >> /tmp/install.log
sudo firewall-cmd --permanent --zone=vdcm_mgmt --set-target=DROP >> /tmp/install.log
echo sudo firewall-cmd --permanent --zone=vdcm_video --set-target=DROP >> /tmp/install.log
sudo firewall-cmd --permanent --zone=vdcm_video --set-target=DROP >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_video --permanent --change-interface=enp94s0f0 >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_video --permanent --change-interface=enp94s0f0 >> /tmp/install.log
echo sudo firewall-cmd --reload >> /tmp/install.log
sudo firewall-cmd --reload >> /tmp/install.log
echo sudo firewall-cmd --get-active-zones >> /tmp/install.log
sudo firewall-cmd --get-active-zones >> /tmp/install.log

echo sudo firewall-cmd --zone=vdcm_mgmt --add-port=22/tcp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --add-port=22/tcp --permanent >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_mgmt --add-port=123/tcp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --add-port=123/tcp --permanent >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_mgmt --add-port=443/tcp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --add-port=443/tcp --permanent >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_mgmt --add-port=1500/tcp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --add-port=1500/tcp --permanent >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_mgmt --add-port=3000/tcp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --add-port=3000/tcp --permanent >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_mgmt --add-port=5003/tcp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --add-port=5003/tcp --permanent >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_mgmt --add-port=8443/tcp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --add-port=8443/tcp --permanent >> /tmp/install.log
echo sudo firewall-cmd --reload >> /tmp/install.log
sudo firewall-cmd --reload >> /tmp/install.log

echo sudo firewall-cmd --zone=vdcm_mgmt --permanent --add-service=grafana --add-service=http --add-service=https --add-service=influxdb --add-service=ntp --add-service=snmp --add-service=ssh --add-service=vdcm-abr2ts --add-service=vdcm-bb-inp-processing-debug --add-service=vdcm-bb-inp-processing-mgmt --add-service=vdcm-esam --add-service=vdcm-iiop --add-service=vdcm-mfp-control-debug --add-service=vdcm-mfp-control-video --add-service=vdcm-mfp-processing-debug --add-service=vdcm-mfp-processing-mgmt --add-service=vdcm-mfp-processing-video --add-service=vdcm-rest --add-service=vdcm-scte-30 --add-service=vdcm-secure-iiop --add-service=vdcm-smi-debug --add-service=vdcm-splicer-video --add-service=vdcm-urc-statmux-client --add-service=vdcm-urc-statmux-controller --add-service=vdcm-xgress-mgmt --add-service=vdsm >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --permanent --add-service=grafana --add-service=http --add-service=https --add-service=influxdb --add-service=ntp --add-service=snmp --add-service=ssh --add-service=vdcm-abr2ts --add-service=vdcm-bb-inp-processing-debug --add-service=vdcm-bb-inp-processing-mgmt --add-service=vdcm-esam --add-service=vdcm-iiop --add-service=vdcm-mfp-control-debug --add-service=vdcm-mfp-control-video --add-service=vdcm-mfp-processing-debug --add-service=vdcm-mfp-processing-mgmt --add-service=vdcm-mfp-processing-video --add-service=vdcm-rest --add-service=vdcm-scte-30 --add-service=vdcm-secure-iiop --add-service=vdcm-smi-debug --add-service=vdcm-splicer-video --add-service=vdcm-urc-statmux-client --add-service=vdcm-urc-statmux-controller --add-service=vdcm-xgress-mgmt --add-service=vdsm >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_video --permanent --add-service=vdcm-mfp-control-video --add-service=vdcm-urc-statmux-client --add-service=vdcm-urc-statmux-controller >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_video --permanent --add-service=vdcm-mfp-control-video --add-service=vdcm-urc-statmux-client --add-service=vdcm-urc-statmux-controller >> /tmp/install.log
echo sudo firewall-cmd --reload >> /tmp/install.log
sudo firewall-cmd --reload >> /tmp/install.log

echo sudo firewall-cmd --zone=vdcm_mgmt --add-protocol=icmp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --add-protocol=icmp --permanent >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_video --add-protocol=icmp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_video --add-protocol=icmp --permanent >> /tmp/install.log
echo sudo firewall-cmd --reload >> /tmp/install.log
sudo firewall-cmd --reload >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_mgmt --add-protocol=icmp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_mgmt --add-protocol=icmp --permanent >> /tmp/install.log
echo sudo firewall-cmd --zone=vdcm_video --add-protocol=icmp --permanent >> /tmp/install.log
sudo firewall-cmd --zone=vdcm_video --add-protocol=icmp --permanent >> /tmp/install.log
echo sudo firewall-cmd --reload >> /tmp/install.log
sudo firewall-cmd --reload >> /tmp/install.log

echo sudo firewall-cmd --runtime-to-permanent >> /tmp/install.log
sudo firewall-cmd --runtime-to-permanent >> /tmp/install.log
echo sudo firewall-cmd --reload >> /tmp/install.log
sudo firewall-cmd --reload >> /tmp/install.log

echo $dt == 4_Install_vDCM - Firewall list-all for vdcm_mgmt >> /tmp/install.log
echo $dt == 4_Install_vDCM - Firewall list-all for vdcm_mgmt
sudo firewall-cmd --zone=vdcm_mgmt --list-all  >> /tmp/install.log

echo $dt == 4_Install_vDCM - Firewall list-all for vdcm_video >> /tmp/install.log
echo $dt == 4_Install_vDCM - Firewall list-all for vdcm_video
sudo firewall-cmd --zone=vdcm_video --list-all >> /tmp/install.log


# 7.8 Updated moved from 2_3_OS_Update
dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Mounting CentOS7_Q2_2020.iso >> /tmp/install.log
echo $dt == 4_Install_vDCM - Mounting CentOS7_Q2_2020.iso

# mount 7.8 upgrade ISO
mkdir /mnt-tmp
mount -o loop /tmp/CentOS7_Q2_2020.iso /mnt-tmp

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Linking ISO as local Yum repo >> /tmp/install.log
echo $dt == 4_Install_vDCM - Linking ISO as local Yum repo

echo [LocalRepo] > /etc/yum.repos.d/LocalRepo.repo
echo name=LocalRepository >> /etc/yum.repos.d/LocalRepo.repo
echo baseurl=file:///mnt-tmp >> /etc/yum.repos.d/LocalRepo.repo
echo enabled=1 >> /etc/yum.repos.d/LocalRepo.repo
echo gpgcheck=1 >> /etc/yum.repos.d/LocalRepo.repo
echo gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 >> /etc/yum.repos.d/LocalRepo.repo

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Running yum update >> /tmp/install.log
echo $dt == 4_Install_vDCM - Running yum update

yum clean all
yum update -y --skip-broken

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Disabling Local Yum repo >> /tmp/install.log
echo $dt == 4_Install_vDCM - Disabling Local Yum repo
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/LocalRepo.repo

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Clearing default yum repos >> /tmp/install.log
echo $dt == 4_Install_vDCM - Clearing default yum repos

mv -if /etc/yum.repos.d/CentOS* /etc/yum.repos.d/Saved/

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 4_Install_vDCM - Finished 4_Install_vDCM.sh >> /tmp/install.log
echo $dt == 4_Install_vDCM - Finished 4_Install_vDCM.sh

reboot