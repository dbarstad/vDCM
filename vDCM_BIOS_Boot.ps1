# /netboot/vDCM_Scripts

Import-module Cisco.imc

$user = "admin"
$password = ConvertTo-SecureString 'Ch@rt3r!' -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$password)

$DHCP_Hosts = import-csv .\dnsmasq.leases -Header date,status,IP,MAC,hostname

ForEach ($Host in $DHCP_Hosts) {

    $handle = Connect-Imc $Host.IP $Imccred
    If ( $handle -ne $null ) {

        $computerRackUnit = get-imcrackunit
        $SerialNumber = $computerRackUnit.Serial
        $SNArray=@()
        import-csv ./sysdata.txt | ForEach-Object { $SNArray += $_.sn }

        ForEach ($Serial in $SNArray) {
            If ($Serial -eq $SerialNumber) {
                Get-ImcBiosSettings | Set-ImcBiosVfPSata -VpPSata Disabled -Force
                Get-ImcBiosSettings | Set-ImcBiosVfPackageCStateLimit -VpPackageCStateLimit "No Limit" -Force
                Get-ImcBiosSettings | Set-ImcBiosVfXPTPrefetch -VpXPTPrefetch "Disabled" -Force
                Get-ImcBiosSettings | Set-ImcBiosVfEPPProfile -VpEPPProfile "Performance" -Force
                
                Get-ImcStorageVirtualDriveCreatorUsingUnusedPhysicalDrive | Set-ImcStorageVirtualDriveCreatorUsingUnusedPhysicalDrive -AdminState trigger -DriveGroup "[1,2]" -RaidLevel 1 -Size 227928 -StripSize default -VirtualDriveName vDCM_boot -Xml -Force

                Get-ImcStorageVirtualDrive -Id 0 | Set-ImcStorageVirtualDrive -AdminAction set-boot-drive -Force

                Start-ImcTransaction
                Get-ImcLsbootDevPrecision | Add-ImcLsbootHdd -Name "hdd" -Order 1 -Slot "MRAID" -State "Enabled" -Type "LOCALHDD"
                Get-ImcLsbootDevPrecision | Add-ImcLsbootPxe -Iptype "IPv4" -Name "pxe" -Order 2 -Slot "L" -State "Enabled" -Type "PXE"
                Complete-ImcTransaction -Force -xml
            }
        }
    Get-ImcRackUnit | Set-ImcRackUnit -AdminPower cycle-immediate -Force
    Disconect-Imc
    }
}

Remove-Item '.\dnsmasq.leases'

