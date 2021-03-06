#!/bin/bash
# /netboot/www/Charter/Cleanup.sh

sleep 15

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Cleanup - Running install cleanup >> /tmp/install.log
echo $dt == Cleanup - Running install cleanup

echo $dt == Cleanup - Removing Cleanup service >> /tmp/install.log
echo $dt == Cleanup - Removing Cleanup service
systemctl disable Cleanup.service
rm -f /etc/systemd/system/Cleanup.service

hwsn=$( cat /sys/class/dmi/id/product_serial )

while IFS==, read -r region hname counter cip cnm cgw mip mnm mgw inip innm ingw egip egnm eggw repo NTP1 NTP2 sn ; do

  echo Checking $sn
  if [[ "$hwsn" == "$sn" ]] ; then
		echo $dt == Cleanup - Matching hwsn success >> /tmp/install.log
		echo $dt == Cleanup - Matching hwsn success
		break
  fi

done < /tmp/sysdata.txt

echo $dt == Cleanup - Injecting local repos >> /tmp/install.log
echo $dt == Cleanup - Injecting local repos

echo [vendor_centos_co76-rh70] > /etc/yum.repos.d/datacenter.repo
echo name=CentOS 7.6 base 20190401 \(rh70\) >> /etc/yum.repos.d/datacenter.repo
echo type=rpm-md >> /etc/yum.repos.d/datacenter.repo
echo baseurl=http://$repo/repos/vendor:/centos:/co76/rh70/  >> /etc/yum.repos.d/datacenter.repo
echo gpgcheck=0 >> /etc/yum.repos.d/datacenter.repo
echo gpgkey=http://$repo/repos/vendor:/centos:/co76/rh70/repodata/repomd.xml.key  >> /etc/yum.repos.d/datacenter.repo
echo enabled=1  >> /etc/yum.repos.d/datacenter.repo
echo [vendor_centos_co76-updates-20190401-rh70] >> /etc/yum.repos.d/datacenter.repo
echo name=centos 7.6 updates 20190401 \(rh70\) >> /etc/yum.repos.d/datacenter.repo
echo type=rpm-md >> /etc/yum.repos.d/datacenter.repo
echo baseurl=http://$repo/repos/vendor:/centos:/co76-updates-20190401/rh70/ >> /etc/yum.repos.d/datacenter.repo
echo gpgcheck=0 >> /etc/yum.repos.d/datacenter.repo
echo gpgkey=http://$repo/repos/vendor:/centos:/co76-updates-20190401/rh70/repodata/repomd.xml.key >> /etc/yum.repos.d/datacenter.repo
echo enabled=1 >> /etc/yum.repos.d/datacenter.repo

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Cleanup - Setting boot order >> /tmp/install.log
echo $dt == Cleanup - Setting boot order

# Clear PXE from boot order
sudo /tmp/ucscfg bootorder set /tmp/boot_order_final.txt

CIMC_Pass=`cat /tmp/CIMC_Pass`

# Collect system data to log for review
echo >> /tmp/install.log
echo =============================================== >> /tmp/install.log
echo >> /tmp/install.log

sudo /tmp/ucscfg show text /cimc >> /tmp/install.log
sudo /tmp/ucscfg show text /bios >> /tmp/install.log
sudo /tmp/ucscfg bootorder get >> /tmp/install.log

curl -GET https://$cip/redfish/v1/Systems/$hwsn -k -u admin:$CIMC_Pass >> /tmp/install.log

echo " " >> /tmp/install.log
echo " " >> /tmp/install.log

memtotal=$( cat /proc/meminfo | grep MemTotal )

echo "Memory capacity presented by cat /proc/meminfo is:"$memtotal":" >> /tmp/install.log

if [[ "$memtotal" == *"196682004"* ]]; then
  echo "Memory capacity is consistent with the baseline" >> /tmp/install.log
else
  echo "Memory capacity is not consistent with baseline" >> /tmp/install.log
fi

ethtool eno1  >> /tmp/install.log
ethtool enp94s0f0  >> /tmp/install.log
ethtool enp94s0f1  >> /tmp/install.log

echo " " >> /tmp/install.log
echo " " >> /tmp/install.log

echo >> /tmp/install.log
echo =============================================== >> /tmp/install.log
echo >> /tmp/install.log

# Show vdcm-confgure check into log
vdcm-configure check >> /tmp/install.log

echo >> /tmp/install.log
echo =============================================== >> /tmp/install.log
echo >> /tmp/install.log

# Validate that the vDCM web UI responds
curl -k https://127.0.0.1/login >> /tmp/install.log

echo >> /tmp/install.log
echo =============================================== >> /tmp/install.log
echo >> /tmp/install.log

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Cleanup - 'ip a' of host >> /tmp/install.log
echo $dt == Cleanup - 'ip a' of host
ip a  >> /tmp/install.log

echo >> /tmp/install.log
echo =============================================== >> /tmp/install.log
echo >> /tmp/install.log

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Cleanup - Pushing logs to image host >> /tmp/install.log
echo $dt == Cleanup - Pushing logs to image host

cp /etc/sysconfig/network-scripts/ifcfg-eno1 /etc/sysconfig/network-scripts/ifcfg-eno1.bak
cp /etc/sysconfig/network-scripts/ifcfg-eno1.dhcp /etc/sysconfig/network-scripts/ifcfg-eno1
ifdown eno1
ifup eno1

sleep 10

dhcphost=`grep -m 1 dhcp-server-identifier /var/lib/dhclient/dhclient--eno1.lease`
dhcphost=${dhcphost:32}
dhcphost=${dhcphost%?}

# Need to parameterize the PXE/SSH host
/tmp/sshpass -p T3pxeGRIC scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /tmp/install.log root@$dhcphost:/netboot/Host_Logs/$hwsn.log

cp /etc/sysconfig/network-scripts/ifcfg-eno1.bak /etc/sysconfig/network-scripts/ifcfg-eno1
ifdown eno1
ifup eno1

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Cleanup - Pushing logs to image host >> /tmp/install.log
echo $dt == Cleanup - Pushing logs to image host

rm -f /tmp/*.iso
rm -f /tmp/sshpass
rm -f /tmp/ucscfg
rm -f /tmp/OS_Patch_Conf.sh
rm -f /tmp/vDCM_Install.sh
rm -f /tmp/Init_vDCM_Server.sh
rm -f /tmp/boot_order_final.txt
rm -f /tmp/vdcm_chtradmin_pass
rm -f /tmp/vdcm_system_pass
rm -f /tmp/sysdata.txt
rm -f /tmp/vdcm-installer-20.0.4-118.sh
rm -f /etc/sysconfig/network-scripts/ifcfg-eno1.dhcp
rm -f /tmp/CIMC_Pass
rm -f /tmp/Cleanup.sh

wall "System configuration complete"
shutdown -h now
