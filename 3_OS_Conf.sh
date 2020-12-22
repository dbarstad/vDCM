#!/bin/bash

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Starting 3_OS_Conf.sh >> /tmp/install.log

dt=`date '+%d/%m/%Y_%H:%M:%S'`

if [ "$#" -lt 1 ] ;
then
  echo No Parameters passed.
  echo No Parameters passed to $dt == 3_OS_Config.sh >> /tmp/install.log
  exit 1
fi

# while getopts "hname:dom:mip:mgw:mnm:hbip:hbgw:hbnm:inip:ingw:innm:egip:eggw:egnm:" flag; do
args="$@ foo"
x=0
for arg in $args
do
#  echo $arg
    case $x in
        "--hname" ) hname=$arg;;
        "--dom" ) domain=$arg;;
        "--mip" ) mgmtip=$arg;;
        "--mgw" ) mgmtgw=$arg;;
        "--mnm" ) mgmtnetmask=$arg;;
        "--hbip" ) hbip=$arg;;
        "--hbgw" ) hbgw=$arg;;
        "--hbnm" ) hbnetmask=$arg;;
        "--inip" ) ingressip=$arg;;
        "--ingw" ) ingressgw=$arg;;
        "--innm" ) ingressnetmask=$arg;;
        "--egip" ) egressip=$arg;;
        "--eggw" ) egressgw=$arg;;
        "--egnm" ) egressnetmask=$arg;;
    esac
    x=$arg
done

## Update hostname and hosts file

sed -i "/$hname/d" /etc/sysconfig/network
sed -i "/$hname/d" /etc/hosts
echo HOSTNAME=$hname.$domain >> /etc/sysconfig/network
hostname $hname
echo $mgmtip $hname $hname.$domain >> /etc/hosts

## edit mgmt network interface settings

sed -i '/PROXY_METHOD="none"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/BROWSER_ONLY="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV4_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6INIT="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_AUTOCONF="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_DEFROUTE="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_ADDR_GEN_MODE="stable-privacy"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/PROXY_METHOD=none/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/BROWSER_ONLY=no/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV4_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6INIT=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_AUTOCONF=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_DEFROUTE=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed -i '/IPV6_ADDR_GEN_MODE=stable-privacy/d' /etc/sysconfig/network-scripts/ifcfg-eno1

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

## edit heartbeat network interface settings

sed -i '/PROXY_METHOD="none"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/BROWSER_ONLY="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV4_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6INIT="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_AUTOCONF="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_DEFROUTE="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_ADDR_GEN_MODE="stable-privacy"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/PROXY_METHOD=none/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/BROWSER_ONLY=no/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV4_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6INIT=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_AUTOCONF=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_DEFROUTE=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed -i '/IPV6_ADDR_GEN_MODE=stable-privacy/d' /etc/sysconfig/network-scripts/ifcfg-eno2

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


## edit ingress network interface settings

sed -i '/PROXY_METHOD="none"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/BROWSER_ONLY="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV4_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6INIT="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_AUTOCONF="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_DEFROUTE="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_ADDR_GEN_MODE="stable-privacy"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/PROXY_METHOD=none/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/BROWSER_ONLY=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV4_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6INIT=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_AUTOCONF=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_DEFROUTE=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed -i '/IPV6_ADDR_GEN_MODE=stable-privacy/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0

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


## edit egress network interface settings

sed -i '/PROXY_METHOD="none"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/BROWSER_ONLY="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV4_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6INIT="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_AUTOCONF="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_DEFROUTE="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_ADDR_GEN_MODE="stable-privacy"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/PROXY_METHOD=none/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/BROWSER_ONLY=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV4_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6INIT=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_AUTOCONF=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_DEFROUTE=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed -i '/IPV6_ADDR_GEN_MODE=stable-privacy/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1

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

## set static route for multicast to use enp94s0f0

sed -i '/224/d' /etc/sysconfig/network-scripts/route-enp94s0f0
echo 224.0.0.0/4 >> /etc/sysconfig/network-scripts/route-enp94s0f0

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
echo $dt == Finished 3_OS_conf.sh.  Rebooting... >> /tmp/install.log

#reboot