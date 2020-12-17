#!/bin/bash

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

sed '/$hname/d' /etc/sysconfig/network
sed '/$mgmtip/d' /etc/hosts
echo HOSTNAME=$hname.$domain >> /etc/sysconfig/network
hostname $hostname
echo $mgmtip $hname $hname.$domain >> /etc/hosts

## edit mgmt network interface settings

sed '/PROXY_METHOD="none"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/BROWSER_ONLY="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV4_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV6INIT="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV6_AUTOCONF="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV6_DEFROUTE="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV6_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV6_ADDR_GEN_MODE="stable-privacy"/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/PROXY_METHOD=none/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/BROWSER_ONLY=no/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV4_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV6INIT=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV6_AUTOCONF=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV6_DEFROUTE=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV6_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/IPV6_ADDR_GEN_MODE=stable-privacy/d' /etc/sysconfig/network-scripts/ifcfg-eno1

sed 's/BOOTPROTO="dhcp"/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-eno1
sed 's/ONBOOT="no"/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eno1
sed 's/BOOTPROTO=dhcp/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-eno1
sed 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eno1

sed '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
sed '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-eno1
echo IPADDR=$mgmtip >> /etc/sysconfig/network-scripts/ifcfg-eno1
echo GATEWAY=$mgmtgw >> /etc/sysconfig/network-scripts/ifcfg-eno1
echo NETMASK=$mgmtnetmask >> /etc/sysconfig/network-scripts/ifcfg-eno1

## edit heartbeat network interface settings

sed '/PROXY_METHOD="none"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/BROWSER_ONLY="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV4_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV6INIT="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV6_AUTOCONF="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV6_DEFROUTE="yes"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV6_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV6_ADDR_GEN_MODE="stable-privacy"/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/PROXY_METHOD=none/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/BROWSER_ONLY=no/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV4_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV6INIT=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV6_AUTOCONF=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV6_DEFROUTE=yes/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV6_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/IPV6_ADDR_GEN_MODE=stable-privacy/d' /etc/sysconfig/network-scripts/ifcfg-eno2

sed 's/BOOTPROTO="dhcp"/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-eno2
sed 's/ONBOOT="no"/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eno2
sed 's/BOOTPROTO=dhcp/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-eno2
sed 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eno2

sed '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
sed '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-eno2
echo IPADDR=$hbip >> /etc/sysconfig/network-scripts/ifcfg-eno2
echo GATEWAY=$hbgw >> /etc/sysconfig/network-scripts/ifcfg-eno2
echo NETMASK=$hbnetmask >> /etc/sysconfig/network-scripts/ifcfg-eno2


## edit ingress network interface settings

sed '/PROXY_METHOD="none"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/BROWSER_ONLY="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV4_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV6INIT="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV6_AUTOCONF="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV6_DEFROUTE="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV6_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV6_ADDR_GEN_MODE="stable-privacy"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/PROXY_METHOD=none/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/BROWSER_ONLY=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV4_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV6INIT=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV6_AUTOCONF=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV6_DEFROUTE=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV6_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/IPV6_ADDR_GEN_MODE=stable-privacy/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0

sed 's/BOOTPROTO="dhcp"/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed 's/ONBOOT="no"/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed 's/BOOTPROTO=dhcp/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0

sed '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
sed '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
echo IPADDR=$ingressip >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
echo GATEWAY=$ingressgw >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0
echo NETMASK=$ingressnetmask >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f0


## edit egress network interface settings

sed '/PROXY_METHOD="none"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/BROWSER_ONLY="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV4_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV6INIT="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV6_AUTOCONF="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV6_DEFROUTE="yes"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV6_FAILURE_FATAL="no"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV6_ADDR_GEN_MODE="stable-privacy"/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/PROXY_METHOD=none/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/BROWSER_ONLY=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV4_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV6INIT=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV6_AUTOCONF=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV6_DEFROUTE=yes/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV6_FAILURE_FATAL=no/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/IPV6_ADDR_GEN_MODE=stable-privacy/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1

sed 's/BOOTPROTO="dhcp"/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed 's/ONBOOT="no"/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed 's/BOOTPROTO=dhcp/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1

sed '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
sed '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
echo IPADDR=$egressip >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
echo GATEWAY=$egressgw >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1
echo NETMASK=$egressnetmask >> /etc/sysconfig/network-scripts/ifcfg-enp94s0f1

## set static route for multicast to use enp94s0f0

echo 224.0.0.0/4 >> /etc/sysconfig/network-scripts/route-enp94s0f0

# ***** reboot *****
# shutdown -r now
