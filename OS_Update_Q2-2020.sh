scp root@10.177.250.84:/netboot/tftp/CentOS7_Q2_2020.iso /tmp
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

reboot