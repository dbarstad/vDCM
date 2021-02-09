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

   $ChassisInfo = Get-ImcRackUnit
                Write-Host "System $( $ChassisInfo.Serial ) with IP $( $Serial.cip ) was configured and rebooted via CIMC tools.  PXE installation is underway."

    }
Disconnect-Imc
