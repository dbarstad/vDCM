#!/bin/bash

echo [vendor_centos_co76-rh70] >> /etc/yum.repos.d/datacenter.repo
echo name=CentOS 7.6 base 20190401 \(rh70\)  >> /etc/yum.repos.d/datacenter.repo
echo type=rpm-md baseurl=http://$1/repos/vendor:/centos:/co76/rh70/  >> /etc/yum.repos.d/datacenter.repo
echo gpgcheck=0 gpgkey=http://$1/repos/vendor:/centos:/co76/rh70/repodata/repomd.xml.key  >> /etc/yum.repos.d/datacenter.repo
echo enabled=1  >> /etc/yum.repos.d/datacenter.repo
echo [vendor_centos_co76-updates-20190401-rh70] >> /etc/yum.repos.d/datacenter.repo
echo name=centos 7.6 updates 20190401 \(rh70\) >> /etc/yum.repos.d/datacenter.repo
echo type=rpm-md baseurl=http://$1/repos/vendor:/centos:/co76-updates-20190401/rh70/ >> /etc/yum.repos.d/datacenter.repo
echo gpgcheck=0 gpgkey=http://$1/repos/vendor:/centos:/co76-updates-20190401/rh70/repodata/repomd.xml.key >> /etc/yum.repos.d/datacenter.repo
echo enabled=1 >> /etc/yum.repos.d/datacenter.repo

yum clean all

yum repolist all

#reboot