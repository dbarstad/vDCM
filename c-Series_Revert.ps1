# /netboot/vDCM_Scripts

Import-module Cisco.imc

$user = "admin"
$ImpPass = Get-Content ./CIMC_Pass
$password = ConvertTo-SecureString $ImpPass -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$password)

$CIMC_IP = Read-Host "Enter IP of CIMC ro revert (x.x.x.x/Default - 10.177.250.140)"

If ( $CIMC_IP -eq "" ) {
    $CIMC_IP = "10.177.250.140"
}
    $handle = Connect-Imc $CIMC_IP $Imccred
    If ( $handle -ne $null ) {
                
                Get-ImcStorageVirtualDrive -Id 0 | Set-ImcStorageVirtualDrive -AdminAction start-fast-initialization -Force
                Get-ImcStorageController | Set-ImcStorageController -AdminAction "clear-boot-drive" -Force
                Get-ImcStorageVirtualDrive | Remove-ImcStorageVirtualDrive -Force
                Get-ImcStorageLocalDisk | Set-ImcStorageLocalDisk -AdminAction make-jbod -Force

                Set-ImcBiosSettings -Force -ResetToPlatformDefault

                Get-ImcLsbootHdd | Remove-ImcLsbootHdd -Force
                Get-ImcLsbootPxe | Remove-ImcLsbootPxe -Force
                Set-ImcAaaUserPolicy -UserPasswordPolicy Disabled -Force
                Get-ImcLocalUser  -AccountStatus "active" | Set-ImcLocalUser -Pwd "password" -Force
                Set-ImcAaaUserPolicy -UserPasswordPolicy Enabled -Force
                #Get-ImcMgmtIf | Set-ImcMgmtIf -DhcpEnable Yes -DnsUsingDhcp Yes -NicMode shared_lom_ext -NicRedundancy active-active -VlanEnable No -Force
                Get-ImcMgmtIf | Set-ImcMgmtIf -DhcpEnable Yes -DnsAlternate 0.0.0.0 -DnsPreferred 0.0.0.0 -DnsUsingDhcp Yes -ExtGw 0.0.0.0 -ExtIp 0.0.0.0 -ExtMask 0.0.0.0 -NicMode shared_lom_ext -NicRedundancy active-active -VlanEnable No -Force
    }
    Get-ImcRackUnit | Set-ImcRackUnit -AdminPower cycle-immediate -Force
Disconnect-Imc
