#!/bin/bash
# /netboot/www/Charter/OS_Patch_Conf.sh

sleep 15

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Starting OS_Patch_Conf >> /tmp/install.log
echo $dt == OS_Patch_Conf - Starting OS_Patch_Conf

# Clearing default REPOS and updating to 7.8
dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Clearing default repos >> /tmp/install.log
echo $dt == OS_Patch_Conf - Clearing default repos
mkdir /etc/yum.repos.d/Saved
mv -i /etc/yum.repos.d/CentOS* /etc/yum.repos.d/Saved/

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Mounting CentOS7_Q2_2020.iso >> /tmp/install.log
echo $dt == OS_Patch_Conf - Mounting CentOS7_Q2_2020.iso

# Update to 7.8 (CantOS_7_Q2_2020.iso) ISO
mkdir /mnt-tmp
mount -o loop /tmp/CentOS7_Q2_2020.iso /mnt-tmp

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Linking ISO as local Yum repo >> /tmp/install.log
echo $dt == OS_Patch_Conf - Linking ISO as local Yum repo

echo [LocalRepo] > /etc/yum.repos.d/LocalRepo.repo
echo name=LocalRepository >> /etc/yum.repos.d/LocalRepo.repo
echo baseurl=file:///mnt-tmp >> /etc/yum.repos.d/LocalRepo.repo
echo enabled=1 >> /etc/yum.repos.d/LocalRepo.repo
echo gpgcheck=1 >> /etc/yum.repos.d/LocalRepo.repo
echo gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 >> /etc/yum.repos.d/LocalRepo.repo

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Running yum update >> /tmp/install.log
echo $dt == OS_Patch_Conf - Running yum update

yum clean all
yum update -y --skip-broken

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Disabling Local Yum repo >> /tmp/install.log
echo $dt == OS_Patch_Conf - Disabling Local Yum repo
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/LocalRepo.repo

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Clearing default yum repos >> /tmp/install.log
echo $dt == OS_Patch_Conf - Clearing default yum repos

mv -if /etc/yum.repos.d/CentOS* /etc/yum.repos.d/Saved/

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Loading hostname and IP details >> /tmp/install.log
echo $dt == OS_Patch_Conf - Loading hostname and IP details

hwsn=$( cat /sys/class/dmi/id/product_serial )

echo $dt == OS_Patch_Conf - Matching hwsn - $hwsn >> /tmp/install.log
echo $dt == OS_Patch_Conf - Matching hwsn - $hwsn

while IFS==, read -r region hname counter cip cgw cnm mip mgw mnm inip ingw innm egip eggw egnm repo NTP1 NTP2 sn; do
	
#  echo Checking $sn
  if [[ "$hwsn" == "$sn" ]] ; then
		echo $dt == OS_Patch_Conf - Matched hwsn success >> /tmp/install.log
		echo $dt == OS_Patch_Conf - Matched hwsn success
        break
  fi

done < /tmp/sysdata.txt

if [[ "$hwsn" != "$sn" ]] ; then
    	echo $dt == OS_Patch_Conf - CRITICAL FAILURE - Failed to match hwsn - $hwsn >> /tmp/install.log
		echo $dt == OS_Patch_Conf - CRITICAL FAILURE - Failed to match hwsn - $hwsn
		exit 1
fi
  
dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Setting date_time for region >> /tmp/install.log
echo $dt == OS_Patch_Conf - Setting date_time for region

case $region in 

	HRC | STD | SLO | BAK | GRD | SDG )
		timedatectl set-timezone US/Pacific
		;;
	FTW | LED | BHM | KSC | LNC | MKE | AUS | SAX | RTX)
		timedatectl set-timezone US/Central
		;;
	OCI)
		timedatectl set-timezone US/Hawaii
		;;
# Test TimeZone - DEN
	DEN)
		timedatectl set-timezone US/Mountain
		;;
#	NWT | TRI | WOR | BRD | FOR | AAB | DEL | IND | CLE | CAN | CIN | CLB | ALB | BNG | BUF | POR | RCH | SYC | BKN | NMN | SMN | QUN | STI | HVN | CLT | CSC | GSO | RAL | WIL | PKV | ROC)
#		timedatectl set-timezone US/Eastern
#		;;
	*)
		timedatectl set-timezone US/Eastern
		;;
esac

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Setting hostname >> /tmp/install.log
echo $dt == OS_Patch_Conf - Setting hostname

## Update hostname and hosts file

sed -i "/$hname/d" /etc/sysconfig/network
sed -i "/$hname/d" /etc/hosts
echo HOSTNAME=$hname >> /etc/sysconfig/network
hostname $hname
echo $mip $hname >> /etc/hosts

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Setting eno1 IF details >> /tmp/install.log
echo $dt == OS_Patch_Conf - Setting eno1 IF details

## edit mgmt network interface settings

cp /etc/sysconfig/network-scripts/ifcfg-eno1 /etc/sysconfig/network-scripts/ifcfg-eno1.dhcp
sed -i '/PROXY_METHOD=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/BROWSER_ONLY=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV4_FAILURE_FATAL=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6INIT=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_AUTOCONF=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_DEFROUTE=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_FAILURE_FATAL=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_ADDR_GEN_MODE=/d' /etc/sysconfig/network-scripts/ifcfg-eno1

sed -i 's/BOOTPROTO="dhcp"/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i 's/ONBOOT="no"/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eno1

sed -i '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
echo IPADDR=$mip >> /etc/sysconfig/network-scripts/ifcfg-eno1
echo GATEWAY=$mgw >> /etc/sysconfig/network-scripts/ifcfg-eno1
echo NETMASK=$mnm >> /etc/sysconfig/network-scripts/ifcfg-eno1
echo DEFROUTE=yes >> /etc/sysconfig/network-scripts/ifcfg-eno1

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Setting enp94s0f0 IF details >> /tmp/install.log
echo $dt == OS_Patch_Conf - Setting enp94s0f0 IF details

## edit ingress network interface settings

sed -i '/PROXY_METHOD=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/BROWSER_ONLY=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV4_FAILURE_FATAL=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6INIT=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_AUTOCONF=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_DEFROUTE=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_FAILURE_FATAL=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_ADDR_GEN_MODE=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0

sed -i 's/BOOTPROTO="dhcp"/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i 's/ONBOOT="no"/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i 's/DEFROUTE=yes/DEFROUTE=no/' >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0

sed -i '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
echo IPADDR=$inip >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
echo GATEWAY=$ingw >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
echo NETMASK=$innm >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0

# Finish rebuild if ifcfg-enp94s0f* if building whole file
if ! grep -q DEVICE /etc/sysconfig/network-scripts/ifcfg-enp94s0f0; then
    echo DEVICE=enp94s0f0 >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
fi
if ! grep -q ONBOOT /etc/sysconfig/network-scripts/ifcfg-enp94s0f0; then
    echo ONBOOT=yes >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
fi
if ! grep -q BOOTPROTO /etc/sysconfig/network-scripts/ifcfg-enp94s0f0; then
    echo BOOTPROTO=static >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
fi
if ! grep -q DEFROUTE /etc/sysconfig/network-scripts/ifcfg-enp94s0f0; then
    echo DEFROUTE=no >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
fi

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Setting enp94s0f1 IF details >> /tmp/install.log
echo $dt == OS_Patch_Conf - Setting enp94s0f1 IF details

## edit egress network interface settings

sed -i '/PROXY_METHOD=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/BROWSER_ONLY=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV4_FAILURE_FATAL=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6INIT=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_AUTOCONF=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_DEFROUTE=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_FAILURE_FATAL=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_ADDR_GEN_MODE=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1

sed -i 's/BOOTPROTO="dhcp"/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i 's/ONBOOT="no"/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i 's/DEFROUTE=yes/DEFROUTE=no/' >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1

sed -i '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
echo IPADDR=$egip >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
echo GATEWAY=$eggw >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
echo NETMASK=$egnm >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1

# Finish rebuild if ifcfg-enp94s0f* if building whole file
if ! grep -q DEVICE /etc/sysconfig/network-scripts/ifcfg-enp94s0f1; then
    echo DEVICE=enp94s0f1 >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
fi
if ! grep -q ONBOOT /etc/sysconfig/network-scripts/ifcfg-enp94s0f1; then
    echo ONBOOT=yes >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
fi
if ! grep -q BOOTPROTO /etc/sysconfig/network-scripts/ifcfg-enp94s0f1; then
    echo BOOTPROTO=static >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
fi
if ! grep -q DEFROUTE /etc/sysconfig/network-scripts/ifcfg-enp94s0f1; then
    echo DEFROUTE=no >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
fi

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Setting multicast route to enp94s0f1>> /tmp/install.log
echo $dt == OS_Patch_Conf - Setting multicast route to enp94s0f1

## set static route for multicast to use enp94s0f1 - Updated per meeting Thad and David - 01202021
sed -i '/224/d' /etc/sysconfig/network-scripts/route-enp94s0f1
echo 224.0.0.0/4 >> /etc/sysconfig/network-scripts/route-enp94s0f1

systemctl restart network

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Configuring iptables >> /tmp/install.log
echo $dt == OS_Patch_Conf - Configuring iptables

iptables -A INPUT -p igmp -j ACCEPT
iptables-save > /etc/sysconfig/iptables

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - setting rp_filter >> /tmp/install.log
echo $dt == OS_Patch_Conf - setting rp_filter

sed -i '/rp_filter/d' /etc/sysctl.conf
echo net.ipv4.conf.enp94s0f0.rp_filter=2 >> /etc/sysctl.conf
sysctl -p

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Disabling rate limiting >> /tmp/install.log
echo $dt == OS_Patch_Conf - Disabling rate limiting

sed -i 's/RateLimitInterval/#RateLimitInterval/' /etc/systemd/journald.conf
sed -i 's/RateLimitBurst/#RateLimitBurst/' /etc/systemd/journald.conf
sed -i 's/##/#/' /etc/systemd/journald.conf

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Enabling support for 'unsupported' SFPs >> /tmp/install.log
echo $dt == OS_Patch_Conf - Enabling support for 'unsupported' SFPs

sed -i '/options ixgbe allow_unsupported_sfp/d' /etc/modprobe.d/ixgbe.conf
echo options ixgbe allow_unsupported_sfp=1 >> /etc/modprobe.d/ixgbe.conf
rmmod ixgbe
modprobe ixgbe
sed -i 's/GRUB_CMDLINE_LINUX=/#GRUB_CMDLINE_LINUX=/' /etc/default/grub
echo "GRUB_CMDLINE_LINUX=\"ixgbe.allow_unsupported_sfp=1\"" >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Configuring vDCM_Install.sh to run on reboot >> /tmp/install.log
echo $dt == OS_Patch_Conf - Configuring vDCM_Install.sh to run on reboot

systemctl disable OS_Patch_Conf.service
systemctl daemon-reload
rm -f /etc/systemd/system/OS_Patch_Conf.service

echo [Unit] > /etc/systemd/system/vDCM_Install.service
echo Description=Invoke vDCM install script  >> /etc/systemd/system/vDCM_Install.service
echo After=network-online.target  >> /etc/systemd/system/vDCM_Install.service
echo  >> /etc/systemd/system/vDCM_Install.service
echo [Service]  >> /etc/systemd/system/vDCM_Install.service
echo Type=simple  >> /etc/systemd/system/vDCM_Install.service
echo ExecStart=/tmp/vDCM_Install.sh  >> /etc/systemd/system/vDCM_Install.service
echo TimeoutStartSec=0  >> /etc/systemd/system/vDCM_Install.service
echo  >> /etc/systemd/system/vDCM_Install.service
echo [Install]  >> /etc/systemd/system/vDCM_Install.service
echo WantedBy=default.target  >> /etc/systemd/system/vDCM_Install.service

systemctl daemon-reload
systemctl enable vDCM_Install.service

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == OS_Patch_Conf - Finished OS_Patch_Conf.  Rebooting... >> /tmp/install.log
echo $dt == OS_Patch_Conf - Finished OS_Patch_Conf.  Rebooting...

reboot