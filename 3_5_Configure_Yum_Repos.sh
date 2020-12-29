#!/bin/bash

## Need to ID correct repo from DC_services.txt per host by ??IP??

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_5_Configure_Yum_Repos - Starting 3_5_Configure_Yum_Repos.sh >> /tmp/install.log

if [[-z $@]]
then
  echo No Parameters passed.
  echo No Parameters passed to $dt == 4_5_Configure_Yum_Repos.sh >> /tmp/install.log
  exit 1
fi

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_5_Configure_Yum_Repos - Inserting Charter internal repos detail >> /tmp/install.log

echo [vendor_centos_co76-rh70] >> /etc/yum.repos.d/datacenter.repo
echo name=CentOS 7.6 base 20190401 \(rh70\)  >> /etc/yum.repos.d/datacenter.repo
echo type=rpm-md baseurl=http://10.177.250.84/centos7_1908/  >> /etc/yum.repos.d/datacenter.repo
echo gpgcheck=0 gpgkey=http://10.177.250.84/centos7_1908/repodata/repomd.xml.key  >> /etc/yum.repos.d/datacenter.repo
echo enabled=1  >> /etc/yum.repos.d/datacenter.repo
echo [vendor_centos_co76-updates-20190401-rh70] >> /etc/yum.repos.d/datacenter.repo
echo name=centos 7.6 updates 20190401 \(rh70\) >> /etc/yum.repos.d/datacenter.repo
echo type=rpm-md baseurl=http://10.177.250.84/centos7_1908/ >> /etc/yum.repos.d/datacenter.repo
echo gpgcheck=0 gpgkey=http://10.177.250.84/centos7_1908/repodata/repomd.xml.key >> /etc/yum.repos.d/datacenter.repo
echo enabled=1 >> /etc/yum.repos.d/datacenter.repo

yum clean all

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_4_Update_Sys_Files - Configuring 4_Install_vDCM.sh to run on reboot >> /tmp/install.log

Systemctl disable 3_5_Configure_Yum_Repos.service
rm -f /etc/systemd/system/3_5_Configure_Yum_Repos.service

echo [Unit] >> /etc/systemd/system/4_Install_vDCM.service
echo Description=Invoke Chapter 4 Install vDCM script  >> /etc/systemd/system/4_Install_vDCM.service
echo After=network-online.target  >> /etc/systemd/system/4_Install_vDCM.service
echo  >> /etc/systemd/system/4_Install_vDCM.service
echo [Service]  >> /etc/systemd/system/4_Install_vDCM.service
echo Type=simple  >> /etc/systemd/system/4_Install_vDCM.service
echo ExecStart=/tmp/4_Install_vDCM.sh  >> /etc/systemd/system/4_Install_vDCM.service
echo TimeoutStartSec=0  >> /etc/systemd/system/4_Install_vDCM.service
echo  >> /etc/systemd/system/4_Install_vDCM.service
echo [Install]  >> /etc/systemd/system/4_Install_vDCM.service
echo WantedBy=default.target  >> /etc/systemd/system/4_Install_vDCM.service

systemctl daemon-reload
systemctl enable 4_Install_vDCM.service

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_5_Configure_Yum_Repos - Finished 3_5_Configure_Yum_Repos.sh.  Rebooting... >> /tmp/install.log

#reboot