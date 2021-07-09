#!/bin/sh
# /netboot/www/Charter/Init_vDCM_Server.sh

cd /tmp

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Init_vDCM_Server - Pulling content and setting service for post kickstart configuration >> /tmp/install.log

dhclient
dhcphost=`grep -m 1 dhcp-server-identifier /var/lib/dhclient/dhclient.leases`
dhcphost=${dhcphost:32}
dhcphost=${dhcphost%?}

echo $dhcphost > /tmp/dhcphost.txt

curl -O http://$dhcphost/Charter/OS_Patch_Conf.sh
curl -O http://$dhcphost/Charter/vDCM_Install.sh
curl -O http://$dhcphost/Charter/Cleanup.sh
curl -O http://$dhcphost/Charter/sysdata.txt
curl -O http://$dhcphost/Charter/CentOS7_Q2_2020.iso
curl -O http://$dhcphost/Charter/vdcm-installer-20.0.4-118.sh
curl -O http://$dhcphost/Charter/ucscfg
curl -O http://$dhcphost/Charter/boot_order_final.txt
curl -O http://$dhcphost/Charter/sshpass
curl -O http://$dhcphost/Charter/vdcm_system_pass
curl -O http://$dhcphost/Charter/vdcm_chtradmin_pass
curl -O http://$dhcphost/Charter/CIMC_Pass

chmod +x /tmp/*.sh
chmod +x /tmp/ucscfg
chmod +x /tmp/sshpass

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Init_vDCM_Server - OS_Patch_Conf.sh to start on reboot >> /tmp/install.log

echo [Unit] > /etc/systemd/system/OS_Patch_Conf.service
echo Description=Invoke OS Patch and Configuration script  >> /etc/systemd/system/OS_Patch_Conf.service
echo After=network-online.target  >> /etc/systemd/system/OS_Patch_Conf.service
echo  >> /etc/systemd/system/OS_Patch_Conf.service
echo [Service]  >> /etc/systemd/system/OS_Patch_Conf.service
echo Type=simple  >> /etc/systemd/system/OS_Patch_Conf.service
echo ExecStart=/tmp/OS_Patch_Conf.sh  >> /etc/systemd/system/OS_Patch_Conf.service
echo TimeoutStartSec=0  >> /etc/systemd/system/OS_Patch_Conf.service
echo  >> /etc/systemd/system/OS_Patch_Conf.service
echo [Install]  >> /etc/systemd/system/OS_Patch_Conf.service
echo WantedBy=default.target  >> /etc/systemd/system/OS_Patch_Conf.service

systemctl daemon-reload
systemctl enable OS_Patch_Conf.service

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Init_vDCM_Server - Configuration to start on reboot >> /tmp/install.log
