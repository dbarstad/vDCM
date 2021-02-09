# 1. Preperation
Generate sysdata.txt file per the included files CSV structure and copy it to the following directories:
/netboot/vDCM_Scripts
/netboot/www/Charter

Rack server and connect the CIMC and eno1 ports to the PXE servers lan segment.
Power on server

# 2. Cisco UCS C-series HU update, BIOS, HDD and CIMC configuration scripts
Script description and usage in order of execution

From PXE host:
# 2.a. Prep_HUU.ps1 - Pulls new HDCP addresses from dnsmasq.leases log file, injects them into the multiserver_config file and invokes python to execute the HUU script
Directory - /netboot/vDCM_Scripts
Environment - Powershell (pwsh)
Script - ./Prep_HUU.ps1

-- Review the output of the script as it will show errors generated from the script on the screen.  Full log of the HUU is in update_HUU.log
-- Individual serer HUU update failures can be re-tried usung the single_huu.sh script.  Usage: single_huu.sh <CIMC IP> <PXE server IP>

# 2.b. vDCM_BIOS_Boot.ps1 - Pushed BIOS settings, configures HDDs in mirror and initializes, sets CIMC IP and admn password.  Reboots host when complete to auto-start PXE OS load
Directory - /netboot/vDCM_Scripts
Environment - Powershell (pwsh)
Script - ./vDCM_BIOS_Boot.ps1

-- Each IP identified as a successful CIMC update from the update_huu.log file is conected to (CIMC) and all config settings are completed.  The final step reboots the server to allow the PXE CentOS load and final app configuration to be completed.
-- Detail from each CIMC (Serial number and configured CIMC IP are pushed to the screen and the BIOS_Boo.log file

# 3. PXE OS load.
-- The PXE server distributes Centos 7.7 Minimal (1908) as the default in the PXE/Kickstart process.  The KickStart leverages the vDCM.cfg file generated from the initial vDCM anaconda.cfg script.  Post processes are created from the install that copies relevant update files, configuration scripts and the vDCM application to the newly loaded OS/host for execution.

# 4.



# vDCM
vDCM install scripts

Push CIMC configs with Powershell - IMC_Automation.ps1
System will boot after firmware updates and BIOS configurations to PXE install w/ KickStart
When KickStart is complete, Execute run_OS_Update.sh
When OS Update reboot is complete, execute run_IF_Config.sh
