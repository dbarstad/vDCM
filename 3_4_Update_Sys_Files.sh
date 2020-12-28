#!/bin/bash

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Starting 3_4_Update_Sys_Files.sh >> /tmp/install.log

iptables -A INPUT -p igmp -j ACCEPT
iptables-save > /etc/sysconfig/iptables

echo net.ipv4.conf.enp94s0f0.rp_filter=2 >> /etc/sysctl.conf
sysctl -p

sed -i 's/RateLimitInterval/#RateLimitInterval/' /etc/systemd/journald.conf
sed -i 's/RateLimitBurst/#RateLimitBurst/' /etc/systemd/journald.conf
sed -i 's/##/#/' /etc/systemd/journald.conf

sed -i '/options ixgbe allow_unsupported_sfp/d' /etc/modprobe.d/ixgbe.conf
echo options ixgbe allow_unsupported_sfp=1 >> /etc/modprobe.d/ixgbe.conf
rmmod ixgbe
modprobe ixgbe

echo "GRUB_CMDLINE_LINUX=\"ixgbe.allow_unsupported_sfp=1\"" >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# Insert yum repos but disable them since installs not happening on Charter networks...bypassing 3_5 since no reboot required.

echo [vendor_centos_co76-rh70] >> /etc/yum.repos.d/datacenter.repo
echo name=CentOS 7.6 base 20190401 \(rh70\)  >> /etc/yum.repos.d/datacenter.repo
echo type=rpm-md baseurl=http://$1/repos/vendor:/centos:/co76/rh70/  >> /etc/yum.repos.d/datacenter.repo
echo gpgcheck=0 gpgkey=http://$1/repos/vendor:/centos:/co76/rh70/repodata/repomd.xml.key  >> /etc/yum.repos.d/datacenter.repo
echo enabled=1  >> /etc/yum.repos.d/datacenter.repo
echo [vendor_centos_co76-updates-20190401-rh70] >> /etc/yum.repos.d/datacenter.repo
echo name=centos 7.6 updates 20190401 \(rh70\) >> /etc/yum.repos.d/datacenter.repo
echo type=rpm-md baseurl=http://$1/repos/vendor:/centos:/co76-updates-20190401/rh70/ >> /etc/yum.repos.d/datacenter.repo
echo gpgcheck=0 gpgkey=http://$1/repos/vendor:/centos:/co76-updates-20190401/rh70/repodata/repomd.xml.key >> /etc/yum.repos.d/datacenter.repo
echo enabled=1 >> /etc/yum.repos.d/datacenter.repo

## Remove
yum-config-manager --disable datacenter
yum-config-manager --disable LocalRepo
yum clean all

Systemctl disable 3_4_Update_Sys_Files.service
rm -f /etc/systemd/system/3_4_Update_Sys_Files.service

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
echo $dt == Finished 3_4_Update_Sys_Files.sh.  Rebooting... >> /tmp/install.log

#reboot