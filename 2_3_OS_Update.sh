# scp root@10.177.250.84:/netboot/tftp/CentOS7_Q2_2020.iso /tmp

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Starting 2_3_OS_Update.sh >> /tmp/install.log

mkdir /mnt-tmp
mount -o loop CentOS7_Q2_2020.iso /mnt-tmp

mkdir /etc/yum.repos.d/Saved
mv -i /etc/yum.repos.d/CentOS* /etc/yum.repos.d/Saved/

echo [LocalRepo] >> /etc/yum.repos.d/LocalRepo.repo
name=LocalRepository >> /etc/yum.repos.d/LocalRepo.repo
baseurl=file:///mnt-tmp >> /etc/yum.repos.d/LocalRepo.repo
enabled=1 >> /etc/yum.repos.d/LocalRepo.repo
gpgcheck=1 >> /etc/yum.repos.d/LocalRepo.repo
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 >> /etc/yum.repos.d/LocalRepo.repo

yum clean all
yum repolist
yum update -y --skip-broken

echo [Unit] >> /etc/systemd/system/3_OS_Conf.service
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

dt=`date '+%d/%m/%Y_%H:%M:%S'`
echo $dt == Finished 2_3_OS_Update.sh.  Rebooting... >> /tmp/install.log

#reboot