# /netboot/vDCM_Scripts

Import-module Cisco.imc

$user = "admin"
$ImpPass = Get-Content ./CIMC_Pass
$password = ConvertTo-SecureString $ImpPass -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$password)

$CIMC_IP = Read-Host "Enter IP of CIMC ro revert (x.x.x.x/Default - 10.177.250.184) :"

If ( $CIMC_IP -eq "" ) {
    $CIMC_IP = "10.177.250.184"
}
    $handle = Connect-Imc $CIMC_IP $Imccred
    If ( $handle -ne $null ) {
                
                Get-ImcStorageVirtualDrive -Id 0 | Set-ImcStorageVirtualDrive -AdminAction start-fast-initialization -Force
                Get-ImcStorageController | Set-ImcStorageController -AdminAction "clear-boot-drive" -Force
                Get-ImcStorageVirtualDrive | Remove-ImcStorageVirtualDrive -Force -Xml
                Get-ImcStorageLocalDisk | Set-ImcStorageLocalDisk -AdminAction make-jbod -Force -Xml

                Set-ImcBiosSettings -Force -ResetToPlatformDefault -Xml

                Get-ImcLsbootHdd | Remove-ImcLsbootHdd -Force -Xml
                Get-ImcLsbootPxe | Remove-ImcLsbootPxe -Force -Xml
    }
    Get-ImcRackUnit | Set-ImcRackUnit -AdminPower cycle-immediate -Force
Disconnect-Imc
