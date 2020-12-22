#!/bin/bash

dt=`date '+%d%m%Y_%H%M%S'`

dr=Bacup_$dt

mkdir $dr

cp *.sh ./$dr



rm -f 2_3_OS_Update.sh
rm -f 3_4_Update_Sys_Files.sh
rm -f 3_5_Configure_Yum_Repos.sh
rm -f 3_OS_Conf.sh
rm -f 4_Install_vDCM.sh
rm -f IF_run.sh
rm -f Init_vDCM_Server.sh