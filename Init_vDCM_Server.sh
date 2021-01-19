#!/bin/sh

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Init_vDCM_Server - Pulling content and setting service for post kickstart configuration >> /tmp/install.log

#curl -O http://10.177.250.84/Charter/2_3_OS_Update.sh
curl -O http://10.177.250.84/Charter/3_4_Update_Sys_Files.sh
curl -O http://10.177.250.84/Charter/3_5_Configure_Yum_Repos.sh
curl -O http://10.177.250.84/Charter/3_OS_Conf.sh
curl -O http://10.177.250.84/Charter/4_Install_vDCM.sh
curl -O http://10.177.250.84/Charter/sysdata.txt
curl -O http://10.177.250.84/Charter/CentOS7_Q2_2020.iso
curl -O http://10.177.250.84/Charter/vdcm-installer-18.0.9-177.sh
curl -O http://10.177.250.84/Charter/ucscfg
curl -O http://10.177.250.84/Charter/boot_order_final.txt

chmod +x /tmp/*.sh
chmod +x /tmp/ucscfg

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Init_vDCM_Server - Configuring 3_OS_Conf.sh to start on reboot >> /tmp/install.log

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
echo $dt == Init_vDCM_Server - Configuration to start on reboot >> /tmp/install.log
