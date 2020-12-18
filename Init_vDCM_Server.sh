#!/bin/sh

dt=`date '+%d/%m/%Y_%H:%M:%S'`

if [[-z $@]]
then
  echo No Parameters passed.
  echo $dt == No Parameters passed to Init_vDCM_Server.sh >> ./install.log
  exit 1
fi

sshpass -f vDCM_Pass scp *.sh root@$1:/tmp
sshpass -f vDCM_Pass scp *.iso root@$1:/tmp

sshpass -f vDCM_Pass ssh root@$1 /tmp/2_3_OS_Update.sh