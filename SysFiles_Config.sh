#!/bin/bash

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

#reboot