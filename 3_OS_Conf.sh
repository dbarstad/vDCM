#!/bin/bash

sleep 30

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_OS_Conf - Starting 3_OS_Conf.sh >> /tmp/install.log

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_OS_Conf - Loading hostname and IP details >> /tmp/install.log

hwsn=$( cat /sys/class/dmi/id/product_serial )

while IFS==, read -r sn hname dom mip mgw mnm DNS1 DNS2 hbip hbgw hbnm inip ingw innm egip eggw egnm repo NTP1 NTP2 ; do

  if [[ "$hwsn" == "$sn" ]] ; then
        break
  fi

done < sysdata.txt

# cp /etc/sysconfig/network-scripts/ifcfg* /tmp

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_OS_Conf - Setting hostname >> /tmp/install.log

## Update hostname and hosts file

sed -i "/$hname/d" /etc/sysconfig/network
sed -i "/$hname/d" /etc/hosts
echo HOSTNAME=$hname >> /etc/sysconfig/network
hostname $hname
echo $mgmtip $hname $hname >> /etc/hosts

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_OS_Conf - Setting eno1 IF details >> /tmp/install.log

## edit mgmt network interface settings

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
echo IPADDR=$mgmtip >> /etc/sysconfig/network-scripts/ifcfg-eno1
echo GATEWAY=$mgmtgw >> /etc/sysconfig/network-scripts/ifcfg-eno1
echo NETMASK=$mgmtnetmask >> /etc/sysconfig/network-scripts/ifcfg-eno1
echo DEFROUTE=yes >> /etc/sysconfig/network-scripts/ifcfg-eno1

### Remove DNS entries for final
if [[ "$DNS1" != "" ]]; then
	echo DNS1=$DNS1 >> /etc/sysconfig/network-scripts/ifcfg-eno1
fi

if [[ "$DNS2" != "" ]]; then
echo DNS2=$DNS2 >> /etc/sysconfig/network-scripts/ifcfg-eno1
fi

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_OS_Conf - Setting eno2 IF details >> /tmp/install.log

## edit heartbeat network interface settings

sed -i '/PROXY_METHOD=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/BROWSER_ONLY=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV4_FAILURE_FATAL=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6INIT=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_AUTOCONF=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_DEFROUTE=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_FAILURE_FATAL=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_ADDR_GEN_MODE=/d' /etc/sysconfig/network-scripts/ifcfg-eno2

sed -i 's/BOOTPROTO="dhcp"/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i 's/ONBOOT="no"/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eno2

sed -i '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
echo IPADDR=$hbip >> /etc/sysconfig/network-scripts/ifcfg-eno2
echo GATEWAY=$hbgw >> /etc/sysconfig/network-scripts/ifcfg-eno2
echo NETMASK=$hbnetmask >> /etc/sysconfig/network-scripts/ifcfg-eno2
echo DEFROUTE=no >> /etc/sysconfig/network-scripts/ifcfg-eno2

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_OS_Conf - Setting enp94s0f0 IF details >> /tmp/install.log

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

sed -i '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
echo IPADDR=$ingressip >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
echo GATEWAY=$ingressgw >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
echo NETMASK=$ingressnetmask >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0

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
echo $dt == 3_OS_Conf - Setting enp94s0f1 IF details >> /tmp/install.log

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

sed -i '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
echo IPADDR=$egressip >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
echo GATEWAY=$egressgw >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
echo NETMASK=$egressnetmask >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1

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
echo $dt == 3_OS_Conf - Setting multicast route  >> /tmp/install.log

## set static route for multicast to use enp94s0f0

sed -i '/224/d' /etc/sysconfig/network-scripts/route-enp94s0f0
echo 224.0.0.0/4 >> /etc/sysconfig/network-scripts/route-enp94s0f0

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_OS_Conf - Configuring 3_4_Update_Sys_Files.sh to run on reboot >> /tmp/install.log

systemctl disable 3_OS_Conf.service
systemctl daemon-reload
rm -f /etc/systemd/system/3_OS_Conf.service

echo [Unit] > /etc/systemd/system/3_4_Update_Sys_Files.service
echo Description=Invoke Chapter 3 Section 4 OS System files updates script  >> /etc/systemd/system/3_4_Update_Sys_Files.service
echo After=network-online.target  >> /etc/systemd/system/3_4_Update_Sys_Files.service
echo  >> /etc/systemd/system/3_4_Update_Sys_Files.service
echo [Service]  >> /etc/systemd/system/3_4_Update_Sys_Files.service
echo Type=simple  >> /etc/systemd/system/3_4_Update_Sys_Files.service
echo ExecStart=/tmp/3_4_Update_Sys_Files.sh  >> /etc/systemd/system/3_4_Update_Sys_Files.service
echo TimeoutStartSec=0  >> /etc/systemd/system/3_4_Update_Sys_Files.service
echo  >> /etc/systemd/system/3_4_Update_Sys_Files.service
echo [Install]  >> /etc/systemd/system/3_4_Update_Sys_Files.service
echo WantedBy=default.target  >> /etc/systemd/system/3_4_Update_Sys_Files.service

systemctl daemon-reload
systemctl enable 3_4_Update_Sys_Files.service

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == 3_OS_Conf - Finished 3_OS_conf.sh.  Rebooting... >> /tmp/install.log

#reboot