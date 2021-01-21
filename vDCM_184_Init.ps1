# /netboot/vDCM_Scripts

Import-module Cisco.imc

$user = "admin"
$ImpPass = Get-Content ./CIMC_Pass
$password = ConvertTo-SecureString $ImpPass -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$password)

    $handle = Connect-Imc 10.177.250.184 $Imccred
    If ( $handle -ne $null ) {
                
                Get-ImcBiosSettings | Set-ImcBiosVfPSata -VpPSata Disabled -Force
                Get-ImcBiosSettings | Set-ImcBiosVfPackageCStateLimit -VpPackageCStateLimit "No Limit" -Force
                Get-ImcBiosSettings | Set-ImcBiosVfXPTPrefetch -VpXPTPrefetch "Disabled" -Force
                Get-ImcBiosSettings | Set-ImcBiosVfEPPProfile -VpEPPProfile "Performance" -Force
                Get-ImcStorageController | Set-ImcStorageController -AdminAction "clear-boot-drive" -Force
                Get-ImcStorageLocalDisk | Set-ImcStorageLocalDisk -AdminAction make-unconfigured-good -Force -Imc $handle -Xml
                Get-ImcStorageVirtualDriveCreatorUsingUnusedPhysicalDrive | Set-ImcStorageVirtualDriveCreatorUsingUnusedPhysicalDrive -AdminState trigger -DriveGroup "[1,2]" -AccessPolicy read-write -CachePolicy direct-io -DiskCachePolicy unchanged -RaidLevel 1 -ReadPolicy no-read-ahead -StripSize 64k -WritePolicy "Write Through" -VirtualDriveName vDCM_boot -Size 227928 -Xml -Force
                
                Get-ImcStorageVirtualDrive -Id 0 | Set-ImcStorageVirtualDrive -AdminAction start-fast-initialization -Force
                Get-ImcStorageVirtualDrive -Id 0 | Set-ImcStorageVirtualDrive -AdminAction set-boot-drive -Force
                Get-ImcStorageFlexUtilVirtualDrive | Set-ImcStorageFlexFlashVirtualDrive -AdminAction erase-vd -Force

                Start-ImcTransaction
                    Get-ImcLsbootDevPrecision | Add-ImcLsbootHdd -Name "hdd" -Order 1 -Slot "MRAID" -State "Enabled" -Type "LOCALHDD"
                    Get-ImcLsbootDevPrecision | Add-ImcLsbootPxe -Iptype "IPv4" -Name "pxe" -Order 2 -Slot "L" -State "Enabled" -Type "PXE"
                Complete-ImcTransaction -Force -xml
            }

    #Get-ImcRackUnit | Set-ImcRackUnit -AdminPower cycle-immediate -Force
Disconnect-Imc
