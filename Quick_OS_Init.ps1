# /netboot/vDCM_Scripts

Import-module Cisco.imc

$user = "admin"
$ImpPass = Get-Content ./CIMC_Pass
$password = ConvertTo-SecureString $ImpPass -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$password)

$handle = Connect-Imc 10.177.250.184 $Imccred

If ( $handle -ne $null ) {


    Get-ImcStorageVirtualDrive -Id 0 | Set-ImcStorageVirtualDrive -AdminAction start-fast-initialization -Force
    Get-ImcRackUnit | Set-ImcRackUnit -AdminPower cycle-immediate -Force

    Disconnect-Imc
    }
