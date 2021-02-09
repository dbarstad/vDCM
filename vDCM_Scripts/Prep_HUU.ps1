# /netboot/vDCM_Scripts

Import-module Cisco.imc

$user = "admin"
$defPass = ConvertTo-SecureString "password" -AsPlainText -Force
$ImpPass = Get-Content ./CIMC_Pass
$password = ConvertTo-SecureString $ImpPass -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$defPass)

$DHCP_Hosts = import-csv ./dnsmasq.leases -Header date,status,IP,MAC,hostname

ForEach ($D_Host in $DHCP_Hosts) {

    $handle = Connect-Imc $D_Host.IP $Imccred
    If ( $handle -ne $null ) {

    (Get-Content ./NIHUU/multiserver_config) | Select-String -pattern $D_Host.IP -notmatch | Out-File ./NIHUU/multiserver_config
    Add-Content ./NIHUU/multiserver_config "address=$($D_Host.IP), user=Admin, password=$($ImpPass), imagefile=ucs-c220m5-huu-4.1.1d.iso"
    }
    (Get-Content ./dnsmasq.leases) | Select-String -pattern $D_Host.IP -notmatch | Out-File .\dnsmasq.leases
}

Get-Content ./dnsmasq.leases | ? {$_.trim() -ne "" } | Out-File .\dnsmasq.leases