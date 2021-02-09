#!/bin/bash
# /netboot/www/Charter/Cleanup.sh

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Running install cleanup >> /tmp/install.log
echo $dt == final - Running install cleanup

echo $dt == final - Removing Cleanup service >> /tmp/install.log
echo $dt == final - Removing Cleanup service
systemctl disable Cleanup.service
rm -f /etc/systemd/system/Cleanup.service

hwsn=$( cat /sys/class/dmi/id/product_serial )

while IFS==, read -r region hname counter cip cgw cnm mip mgw mnm inip ingw innm egip eggw egnm repo NTP1 NTP2 sn ; do

  echo Checking $sn
  if [[ "$hwsn" == "$sn" ]] ; then
		echo $dt == Cleanup - Matching hwsn success >> /tmp/install.log
		echo $dt == Cleanup - Matching hwsn success
		break
  fi

done < /tmp/sysdata.txt

echo $dt == final - Injecting local repos >> /tmp/install.log
echo $dt == final - Injecting local repos

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

# Clear PXE from boot order
sudo /tmp/ucscfg bootorder set /tmp/boot_order_final.txt

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - 'ip a' of host >> /tmp/install.log
echo $dt == final - 'ip a' of host
ip a  >> /tmp/install.log

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Pushing logs to image host >> /tmp/install.log
echo $dt == final - Pushing logs to image host

# Need to parameterize the PXE/SSH host
./sshpass -f Img_Svr_Pass scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /tmp/install.log root@10.177.250.84:/netboot/Host_Logs/$hwsn.txt

# shutdown -h now