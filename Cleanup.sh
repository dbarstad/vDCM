#!/bin/bash
# /netboot/www/Charter/Cleanup.sh

hwsn=$( cat /sys/class/dmi/id/product_serial )

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Running vdcm-configure fix >> /tmp/install.log
echo $dt == final - Running vdcm-configure fix

vdcm-configure fix

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Resetting time services >> /tmp/install.log
echo $dt == final - Resetting time services

systemctl restart vdcm-timemaster.service

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Adding systems user >> /tmp/install.log
echo $dt == final - Adding systems user

vdcm-configure user --add systems --passphrase "Ch@rt3r!5" --ignore-passphrase-policy --iiop-admin --rest-user --gui-admin

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Running install cleanup >> /tmp/install.log
echo $dt == final - Running install cleanup

# Clear PXE from boot order
sudo /tmp/ucscfg bootorder set /tmp/boot_order_final.txt

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == final - Pushing logs to image host >> /tmp/install.log
echo $dt == final - Pushing logs to image host

ip a  >> /tmp/install.log

./sshpass -f Img_Svr_Pass scp /tmp/install.log root@10.177.250.84/netboot/Host_Logs/$hwsn.txt