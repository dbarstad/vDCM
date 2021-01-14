#!/bin/bash

sleep 30

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_4_Update_Sys_Files - Starting 3_4_Update_Sys_Files.sh >> /tmp/install.log
echo $dt == 3_4_Update_Sys_Files - Starting 3_4_Update_Sys_Files.sh

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_4_Update_Sys_Files - Configuring iptables >> /tmp/install.log
echo $dt == 3_4_Update_Sys_Files - Configuring iptables

iptables -A INPUT -p igmp -j ACCEPT
iptables-save > /etc/sysconfig/iptables

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_4_Update_Sys_Files - setting rp_filter >> /tmp/install.log
echo $dt == 3_4_Update_Sys_Files - setting rp_filter

sed -i '/rp_filter/d' /etc/sysctl.conf
echo net.ipv4.conf.enp94s0f0.rp_filter=2 >> /etc/sysctl.conf
sysctl -p

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_4_Update_Sys_Files - Disabling rate limiting >> /tmp/install.log
echo $dt == 3_4_Update_Sys_Files - Disabling rate limiting

sed -i 's/RateLimitInterval/#RateLimitInterval/' /etc/systemd/journald.conf
sed -i 's/RateLimitBurst/#RateLimitBurst/' /etc/systemd/journald.conf
sed -i 's/##/#/' /etc/systemd/journald.conf

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_4_Update_Sys_Files - Enabling support for 'unsupported' SFPs >> /tmp/install.log
echo $dt == 3_4_Update_Sys_Files - Enabling support for 'unsupported' SFPs

sed -i '/options ixgbe allow_unsupported_sfp/d' /etc/modprobe.d/ixgbe.conf
echo options ixgbe allow_unsupported_sfp=1 >> /etc/modprobe.d/ixgbe.conf
rmmod ixgbe
modprobe ixgbe
sed -i 's/GRUB_CMDLINE_LINUX=/#GRUB_CMDLINE_LINUX=/' /etc/default/grub
echo "GRUB_CMDLINE_LINUX=\"ixgbe.allow_unsupported_sfp=1\"" >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_4_Update_Sys_Files - Configuring 3_5_Configure_Yum_Repos.sh to run on reboot >> /tmp/install.log
echo $dt == 3_4_Update_Sys_Files - Configuring 3_5_Configure_Yum_Repos.sh to run on reboot

Systemctl disable 3_4_Update_Sys_Files.service
rm -f /etc/systemd/system/3_4_Update_Sys_Files.service

echo [Unit] >> /etc/systemd/system/3_5_Configure_Yum_Repos.service
echo Description=Invoke Chapter 3 Section 5 Configure Yum Repos script  >> /etc/systemd/system/3_5_Configure_Yum_Repos.service
echo After=network-online.target  >> /etc/systemd/system/3_5_Configure_Yum_Repos.service
echo  >> /etc/systemd/system/3_5_Configure_Yum_Repos.service
echo [Service]  >> /etc/systemd/system/3_5_Configure_Yum_Repos.service
echo Type=simple  >> /etc/systemd/system/3_5_Configure_Yum_Repos.service
echo ExecStart=/tmp/3_5_Configure_Yum_Repos.sh  >> /etc/systemd/system/3_5_Configure_Yum_Repos.service
echo TimeoutStartSec=0  >> /etc/systemd/system/3_5_Configure_Yum_Repos.service
echo  >> /etc/systemd/system/3_5_Configure_Yum_Repos.service
echo [Install]  >> /etc/systemd/system/3_5_Configure_Yum_Repos.service
echo WantedBy=default.target  >> /etc/systemd/system/3_5_Configure_Yum_Repos.service

systemctl daemon-reload
systemctl enable 3_5_Configure_Yum_Repos.service

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_4_Update_Sys_Files - Finished 3_4_Update_Sys_Files.sh.  Rebooting... >> /tmp/install.log
echo $dt == 3_4_Update_Sys_Files - Finished 3_4_Update_Sys_Files.sh.  Rebooting...

reboot