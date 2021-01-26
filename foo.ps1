# /netboot/vDCM_Scripts

Import-module Cisco.imc

$user = "admin"
$ImpPass = "password"
$password = ConvertTo-SecureString $ImpPass -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$password)

$CIMC_IP = Read-Host "Enter IP of CIMC ro revert (x.x.x.x/Default - 10.177.250.184) :"

If ( $CIMC_IP -eq "" ) {
    $CIMC_IP = "10.177.250.184"
}
    $handle = Connect-Imc $CIMC_IP $Imccred
