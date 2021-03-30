# 1. Preparation/Requirements
Generate sysdata.txt (CSV text file) file per the included files CSV structure and copy it to the following directories:
Directory - /netboot/vDCM_Scripts/
- Copy to /netboot/vDCM_Scripts folder and execute the Prep_sysdata.sh
- File will be valdiated for dos characters (CR/LF) and spaces.  Copied to /netboot/www/Charter when validated

Generate CIMC_pass (simple text) file with the CIMC admin user password to be pulled into the scripts for use on execution
Directory - /netboot/ vDCM_Scripts/
****> echo <password> > CIMC_pass

Generate vdcm_system_pass (simple text) file with the VDCM software user password to be pulled into the scripts for use on execution
Directory - /netboot/www/Charter/
****> echo <password> > vdcm_system_pass

Generate vdcm_chtradmin_pass (simple text) file with the VDCM software user password to be pulled into the scripts for use on execution
Directory - /netboot/www/Charter/
****> echo <password> > vdcm_chtradmin_pass

Cisco C220 M5 system configured per vDCM standard
Rack server and connect the CIMC and eno1 ports to the PXE server’s LAN segment.
Power on server
*** System should be powered on ~10 minutes before starting scripts to ensure host is in 'Ready' state ***

# 2. Cisco UCS C-series HU update, BIOS, HDD and CIMC configuration scripts
Script description and usage in order of execution

From PXE host:
# 2.a. Prep_HUU.ps1 - Pulls DHCP addresses for CIMCs from dnsmasq.leases log file, validates they are a CIMC by connecting, changes the CIMC admin user password, injects them into the multiserver_config file and invokes python to execute the HUU script
Directory - /netboot/vDCM_Scripts
Environment - Powershell (pwsh)
Script - ./Prep_HUU.ps1

-- Review the output of the script as it will show errors generated from the script on the screen.  Full log of the HUU is in update_huu.log 
-- Individual serer HUU update failures can be re-tried using the single_huu.sh script.  Usage: single_huu.sh <target CIMC IP> <PXE Host IP> <PXE Host Login> <PXE login password>

# 2.b. vDCM_BIOS_Boot.ps1 - Pushed BIOS settings, configures HDDs in mirror and initializes, sets CIMC IP and admin password.  Reboots host when complete to auto-start PXE OS load
Directory - /netboot/vDCM_Scripts
Environment - Powershell (pwsh)
Script - ./vDCM_BIOS_Boot.ps1

-- Each IP identified as a CIMC address from the dnsmasq.leases file is connected to.  All BIOS, CIMC and storage configurations are made.  The final step reboots the server to allow the PXE CentOS load and final app configuration to be completed.
-- Confirmation from each CIMC by serial number are pushed to the screen and the vDCM_BIOS_Boot.log file

# 3. PXE/KickStart OS load - This entire section down to section 4 is automated and detail is provided for reference purposes.
-- The PXE server distributes Centos 7.7 Minimal (1908) as the default in the PXE/Kickstart process.  The KickStart leverages the vDCM.cfg file generated from the initial vDCM anaconda.cfg script.  Post processes are created from the install that copies relevant update files, configuration scripts and the vDCM application to the newly loaded OS/host for execution.

# 3.a ** Init_vDCM_Server.sh **
** Run automatically from the PXE and service invoked scripts on restart **
Directory - PXE_Host: /netboot/www/Charter/Init_vDCM_Server.sh -- vDCM_Host: /tmp
Environment - vDCM host bash script
Script - Init_vDCM_Server.sh

Post Installation files pulled to host in KickStart via the Init_vDCM_Server.sh:
http://<PXE Host>/Charter/OS_Patch_Conf.sh - First reboot script described in step 3b
http://<PXE Host>/Charter/vDCM_Install.sh - Second reboot script described in step 3c
http://<PXE Host>/Charter/Cleanup.sh - Third and final reboot script described in step 3d
http://<PXE Host>/Charter/sysdata.txt - Data file prepared and pushed in step 1. Preparation
http://<PXE Host>/Charter/CentOS7_Q2_2020.iso - CentOS 7.8 (Q2_2020) ISO used for patching in step 3b
http://<PXE Host>/Charter/vdcm-installer-20.0.4-118.sh - vDCM software installed in step 3c
http://<PXE Host>/Charter/ucscfg - Cisco UCS utility to revert boot configuration to final state
http://<PXE Host>/Charter/boot_order_final.txt - Cisco UCS utility setting file to insert
http://<PXE Host>/Charter/sshpass - SSH utility to enable non-interactive action
http://<PXE Host>/Charter/vdcm_system_pass - Password file for vDCM software system user configuration
http://<PXE Host>/Charter/vdcm_chtradmin_pass - Password file for vDCM chtradmin system user configuration

# 3b. ** OS_Patch_Conf.sh **
** Run automatically from the PXE and service invoked scripts on restart **
Directory - PXE_Host: /netboot/www/Charter/ -- vDCM_Host: /tmp/
Environment - vDCM host bash script
Script - OS_Patch_Conf.sh

Set hostname, configure network interfaces, set timezone, IPTABLES, GRUB entry for SFPs, yum repos, OS patching, set vDCM_Install.sh to run on reboot

# 3c. ** vDCM_Install.sh **
** Run automatically from the PXE and service invoked scripts on restart **
Directory - PXE_Host: /netboot/www/Charter/ -- vDCM_Host: /tmp/
Environment - vDCM host bash script
Script - vDCM_Install.sh

Install vDCM version 20.0.4-118, configure interfaces, configure users, sync NTP, configure firewall, set Cleanup.sh to run on reboot

# 3d. ** Cleanup.sh **
** Run automatically from the PXE and service invoked scripts on restart **
Directory - PXE_Host: /netboot/www/Charter/ -- vDCM_Host: /tmp/
Environment - vDCM host bash script
Script - Cleanup.sh

Inject final Charter local yum repo configs, set final bot order and push completed logs to the PXE/Kickstart host

# 4. Verify logs from /netboot/Host_Logs
Systems that have completed the full installation/configuration have pushed the logs of steps 3a-3d to a file named by its serial number into /netboot/Host_Logs/

-- audit the logs pushed back to PXE Server and identified by the serial number of the unit
   -- Validate interface entries (IPs, netmasks, NTP..)
     -- grep eno1 *.log
     -- grep enp94s0f0 *.log
     -- grep enp94s0f1 *.log
     -- grep NTP *.log
     --- all can be compared to the attached IP Assignments - 3-10-2021.xls (Merged_List tab)
   -- review logs for
     -- curl of vDCM app local web page login (raw html...proves vDCM services online)

Systems with log files present can be packed and shipped
Systems that do not post logs in a timely manner (~1hr), should be reviewed via the console (direct connection) for status and troubleshooting
