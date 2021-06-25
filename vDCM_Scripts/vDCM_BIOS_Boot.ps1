# /netboot/vDCM_Scripts

Import-module Cisco.imc

$Host_Updated = 0
Remove-Item vDCM_BIOS_Boot.log
New-Item -itemType File -Name vDCM_BIOS_Boot.log

$user = "admin"
# $defPass = ConvertTo-SecureString "password" -AsPlainText -Force
$ImpPass = Get-Content ./CIMC_Pass
$CIMCpass = ConvertTo-SecureString $ImpPass -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$CIMCPass)

$DHCP_Hosts = import-csv dnsmasq.leases -Header date,status,IP,MAC,hostname

ForEach ($D_Host in $DHCP_Hosts) {

  If ($D_Host.hostname.StartsWith("C220-")) {
    Write-Host "Connecting to $($D_Host.hostname) on IP $($D_Host.IP)"
    $handle = Connect-Imc -Name $D_Host.IP $Imccred
    If ( $handle -ne $null ) {

        $computerRackUnit = get-imcrackunit
        $SerialNumber = $computerRackUnit.Serial
        $SNArray=import-csv ./sysdata.txt
        Write-Host "Checking sysdata.txt for $($SerialNumber)"

        ForEach ($Serial in $SNArray) {
            If ($Serial.sn -eq $SerialNumber) {
                
                Write-Host "Serial Number $($SerialNumber) found in sysdata.txt.  Pushing configuration."
                Get-ImcLsbootDevPrecision | Set-ImcLsbootDevPrecision -ConfiguredBootMode Legacy -Force -RebootOnUpdate No
                Get-ImcBiosSettings | Set-ImcBiosVfPSata -VpPSata Disabled -Force
                Get-ImcBiosSettings | Set-ImcBiosVfPackageCStateLimit -VpPackageCStateLimit "No Limit" -Force
                Get-ImcBiosSettings | Set-ImcBiosVfXPTPrefetch -VpXPTPrefetch "Disabled" -Force
                Get-ImcBiosSettings | Set-ImcBiosVfEPPProfile -VpEPPProfile "Performance" -Force
                
                Get-ImcStorageLocalDisk | Set-ImcStorageLocalDisk -AdminAction make-unconfigured-good -Force -Imc $handle
                Get-ImcStorageVirtualDriveCreatorUsingUnusedPhysicalDrive | Set-ImcStorageVirtualDriveCreatorUsingUnusedPhysicalDrive -AdminState trigger -DriveGroup "[1,2]" -AccessPolicy read-write -CachePolicy direct-io -DiskCachePolicy unchanged -RaidLevel 1 -ReadPolicy no-read-ahead -StripSize 64k -WritePolicy "Write Through" -VirtualDriveName vDCM_boot -Size 227928 -Force
                Get-ImcStorageVirtualDrive -Id 0 | Set-ImcStorageVirtualDrive -AdminAction set-boot-drive -Force
                Get-ImcStorageVirtualDrive -Id 0 | Set-ImcStorageVirtualDrive -AdminAction start-fast-initialization -Force

                Get-ImcStorageFlexUtilVirtualDrive | Set-ImcStorageFlexFlashVirtualDrive -AdminAction erase-vd -Force
 
                Get-ImcLsbootDevPrecision | Set-ImcLsbootDevPrecision -ConfiguredBootMode Legacy -Force -RebootOnUpdate No
                Start-ImcTransaction  
                    Get-ImcLsbootDevPrecision | Add-ImcLsbootHdd -Name "hdd" -Order 1 -Slot "MRAID" -State "Enabled" -Type "LOCALHDD"
                    Get-ImcLsbootDevPrecision | Add-ImcLsbootPxe -Iptype "IPv4" -Name "pxe" -Order 2 -Slot "L" -State "Enabled" -Type "PXE"
                Complete-ImcTransaction -Force
#                Get-ImcLocalUser  -AccountStatus "active" | Set-ImcLocalUser -Pwd $ImpPass -Force
                Get-ImcRackUnit | Set-ImcRackUnit -AdminPower hard-reset-immediate -Force
                $ChassisInfo = Get-ImcRackUnit
                Get-ImcMgmtIf | Set-ImcMgmtIf -AdminDuplex auto -AdminNetSpeed auto -AutoNeg Enabled -DhcpEnable No -DnsUsingDhcp No -V6extEnabled No -ExtGw $Serial.cgw -ExtIp $Serial.cip -ExtMask $Serial.cnm -NicMode dedicated -NicRedundancy none -VlanEnable No -Force
                $Host_Updated = 1
            }
        }
        If ($Host_Updated) {
            Write-Host "System $( $ChassisInfo.Serial ) with IP $( $Serial.cip ) was configured and rebooted via CIMC tools.  PXE installation is underway."
            Add-Content vDCM_BIOS_Boot.log "System $( $ChassisInfo.Serial ) with IP $( $Serial.cip ) was configured and rebooted via CIMC tools.  PXE installation is underway."
            $Host_Updated = 0
            }
        Else {        
            Write-Host "System with IP $( $D_Host.IP ) could not be connected to via CIMC tools."
            Add-Content vDCM_BIOS_Boot.log "System with IP $( $D_Host.IP ) could not be connected to via CIMC tools."
        }
    Disconnect-Imc
    }
  }
}

(Get-Content -Path update_huu.log) -replace $Log_Search_Text, "CIMC updated" | Out-File update_huu.log
