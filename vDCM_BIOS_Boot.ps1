# /netboot/vDCM_Scripts

Import-module Cisco.imc

$user = "admin"
$defPass = ConvertTo-SecureString "password" -AsPlainText -Force
$ImpPass = Get-Content ./CIMC_Pass
$password = ConvertTo-SecureString $ImpPass -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$defPass)

$DHCP_Hosts = import-csv ./dnsmasq.leases -Header date,status,IP,MAC,hostname

#ForEach ($D_Host in $DHCP_Hosts) {

    $handle = Connect-Imc $D_Host.IP $Imccred
#    If ( $handle -ne $null ) {

        $computerRackUnit = get-imcrackunit
        $SerialNumber = $computerRackUnit.Serial
        $SNArray=@()
        import-csv ./sysdata.txt | ForEach-Object { $SNArray += $_.sn }

 #       ForEach ($Serial in $SNArray) {
 #           If ($Serial -eq $SerialNumber) {
                
                Get-ImcBiosSettings | Set-ImcBiosVfPSata -VpPSata Disabled -Force
                Get-ImcBiosSettings | Set-ImcBiosVfPackageCStateLimit -VpPackageCStateLimit "No Limit" -Force
                Get-ImcBiosSettings | Set-ImcBiosVfXPTPrefetch -VpXPTPrefetch "Disabled" -Force
                Get-ImcBiosSettings | Set-ImcBiosVfEPPProfile -VpEPPProfile "Performance" -Force
                
                Get-ImcStorageLocalDisk | Set-ImcStorageLocalDisk -AdminAction make-unconfigured-good -Force -Imc $handle
                Get-ImcStorageVirtualDriveCreatorUsingUnusedPhysicalDrive | Set-ImcStorageVirtualDriveCreatorUsingUnusedPhysicalDrive -AdminState trigger -DriveGroup "[1,2]" -AccessPolicy read-write -CachePolicy direct-io -DiskCachePolicy unchanged -RaidLevel 1 -ReadPolicy no-read-ahead -StripSize 64k -WritePolicy "Write Through" -VirtualDriveName vDCM_boot -Size 227928 -Force
                
                Get-ImcStorageVirtualDrive -Id 0 | Set-ImcStorageVirtualDrive -AdminAction start-fast-initialization -Force
                Get-ImcStorageVirtualDrive -Id 0 | Set-ImcStorageVirtualDrive -AdminAction set-boot-drive -Force

                Get-ImcStorageFlexUtilVirtualDrive | Set-ImcStorageFlexFlashVirtualDrive -AdminAction erase-vd

                Start-ImcTransaction
                    Get-ImcLsbootDevPrecision | Add-ImcLsbootHdd -Name "hdd" -Order 1 -Slot "MRAID" -State "Enabled" -Type "LOCALHDD"
                    Get-ImcLsbootDevPrecision | Add-ImcLsbootPxe -Iptype "IPv4" -Name "pxe" -Order 2 -Slot "L" -State "Enabled" -Type "PXE"
                Complete-ImcTransaction -Force
                Get-ImcLocalUser  -AccountStatus "active" | Set-ImcLocalUser -Pwd $ImpPass -Force
                Get-ImcRackUnit | Set-ImcRackUnit -AdminPower cycle-immediate -Force
                Get-ImcMgmtIf | Set-ImcMgmtIf -DhcpEnable No -DnsUsingDhcp No -ExtGw 10.177.250.1 -ExtIp 10.177.250.140 -ExtMask 255.255.255.0 -NicMode dedicated -NicRedundancy none -V4IPAddr -VlanEnable No -Force
 #           }
 #       }
    Get-ImcRackUnit | Set-ImcRackUnit -AdminPower cycle-immediate -Force

    (Get-Content ./NIHUU/multiserver_config) | Select-String -pattern $D_Host.IP -notmatch | Out-File ./NIHUU/multiserver_config
    Add-Content ./NIHUU/multiserver_config "address=$($D_Host.IP), user=Admin, password=$($ImpPass), imagefile=ucs-c220m5-huu-4.1.1d.iso"
    Disconnect-Imc
#    }
    (Get-Content ./dnsmasq.leases) | Select-String -pattern $D_Host.IP -notmatch | Out-File .\dnsmasq.leases
#}

Get-Content ./dnsmasq.leases | ? {$_.trim() -ne "" } | Out-File .\dnsmasq.leases