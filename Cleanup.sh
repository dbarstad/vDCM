#!/bin/bash
# /netboot/www/Charter/Cleanup.sh

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Running install cleanup >> /tmp/install.log
echo $dt == final - Running install cleanup

hwsn=$( cat /sys/class/dmi/id/product_serial )

while IFS==, read -r region hname counter cip cgw cnm mip mgw mnm inip ingw innm egip eggw egnm repo NTP1 NTP2 sn ; do

  echo Checking $sn
  if [[ "$hwsn" == "$sn" ]] ; then
		echo $dt == 3_5_Configure_Yum_Repos - Matching hwsn success >> /tmp/install.log
		echo $dt == 3_5_Configure_Yum_Repos - Matching hwsn success
		break
  fi

done < /tmp/sysdata.txt

# Replacing temp repo with Charter true repos

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

#dt=`date '+%d/%m/%Y_%H:%M:%S'`
#echo $dt == final - Adding systems user >> /tmp/install.log
#echo $dt == final - Adding systems user

#vdcm-configure user --add systems --passphrase "Ch@rt3r!5" --ignore-passphrase-policy --iiop-admin --rest-user --gui-admin

# Clear PXE from boot order
sudo /tmp/ucscfg bootorder set /tmp/boot_order_final.txt

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Pushing logs to image host >> /tmp/install.log
echo $dt == final - Pushing logs to image host

ip a  >> /tmp/install.log

./sshpass -f Img_Svr_Pass scp /tmp/install.log root@10.177.250.84/netboot/Host_Logs/$hwsn.txt