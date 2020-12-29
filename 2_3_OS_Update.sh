#!/bin/sh

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 2_3_OS_Update - Starting 2_3_OS_Update.sh >> /tmp/install.log

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 2_3_OS_Update - Mounting CentOS7_Q2_2020.iso >> /tmp/install.log

# mount 7.8 upgrade ISO
mkdir /mnt-tmp
mount -o loop /tmp/CentOS7_Q2_2020.iso /mnt-tmp

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 2_3_OS_Update - Linking ISO as local Yum repo >> /tmp/install.log

mkdir /etc/yum.repos.d/Saved
mv -i /etc/yum.repos.d/CentOS* /etc/yum.repos.d/Saved/

echo [LocalRepo] > /etc/yum.repos.d/LocalRepo.repo
echo name=LocalRepository >> /etc/yum.repos.d/LocalRepo.repo
echo baseurl=file:///mnt-tmp >> /etc/yum.repos.d/LocalRepo.repo
echo enabled=1 >> /etc/yum.repos.d/LocalRepo.repo
echo gpgcheck=1 >> /etc/yum.repos.d/LocalRepo.repo
echo gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 >> /etc/yum.repos.d/LocalRepo.repo

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 2_3_OS_Update - Running yum update >> /tmp/install.log

yum clean all
yum update -y --skip-broken

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 2_3_OS_Update - Clearing default yum repos >> /tmp/install.log

mv -if /etc/yum.repos.d/CentOS* /etc/yum.repos.d/Saved/

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 2_3_OS_Update - Setting 3_OS_Conf.sh to run on reboot >> /tmp/install.log

systemctl disable 2_3_OS_Update.service
systemctl daemon-reload
rm -f /etc/systemd/system/2_3_OS_Update.service

echo [Unit] > /etc/systemd/system/3_OS_Conf.service
echo Description=Invoke Chapter 3 OS Configuration script  >> /etc/systemd/system/3_OS_Conf.service
echo After=network-online.target  >> /etc/systemd/system/3_OS_Conf.service
echo  >> /etc/systemd/system/3_OS_Conf.service
echo [Service]  >> /etc/systemd/system/3_OS_Conf.service
echo Type=simple  >> /etc/systemd/system/3_OS_Conf.service
echo ExecStart=/tmp/3_OS_Conf.sh  >> /etc/systemd/system/3_OS_Conf.service
echo TimeoutStartSec=0  >> /etc/systemd/system/3_OS_Conf.service
echo  >> /etc/systemd/system/3_OS_Conf.service
echo [Install]  >> /etc/systemd/system/3_OS_Conf.service
echo WantedBy=default.target  >> /etc/systemd/system/3_OS_Conf.service

systemctl daemon-reload
systemctl enable 3_OS_Conf.service

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 2_3_OS_Update - Finished 2_3_OS_Update.sh.  Rebooting... >> /tmp/install.log

reboot