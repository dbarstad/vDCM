#!/bin/bash
dos2unix sysdata.txt

if grep -q " " sysdata.txt; then
  echo \*\*\* SPACES FOUND IN FILE.  FIX BEFORE EXECUTING NEXT BATCH \*\*\*
else
  echo No spaces found in the sysdata.txt file.
fi

cp -f /netboot/vDCM_Scripts/sysdata.txt /netboot/www/Charter/sysdata.txt

echo Validated file copied to www directory.
