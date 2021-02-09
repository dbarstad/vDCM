# /netboot/vDCM_Scripts

Import-module Cisco.imc

$user = "admin"
$defPass = ConvertTo-SecureString "password" -AsPlainText -Force
$ImpPass = Get-Content ./CIMC_Pass
$password = ConvertTo-SecureString $ImpPass -AsPlainText -Force

# Need to change thie to $defPass for production
$Imccred = New-Object System.Management.Automation.PSCredential($user,$password)

$DHCP_Hosts = import-csv ./dnsmasq.leases -Header date,status,IP,MAC,hostname

ForEach ($D_Host in $DHCP_Hosts) {

    If ( $D_Host.status -eq "add" ) {

    (Get-Content ./multiserver_config) | Select-String -pattern $D_Host.IP -notmatch | Out-File ./multiserver_config
    Add-Content ./multiserver_config "address=$($D_Host.IP), user=Admin, password=$($ImpPass), imagefile=ucs-c220m5-huu-4.1.1d.iso"
    }
    (Get-Content ./dnsmasq.leases) | Select-String -pattern $D_Host.IP -notmatch | Out-File .\dnsmasq.leases
    Disconnect-Imc
}

Get-Content ./dnsmasq.leases | ? {$_.trim() -ne "" } | Out-File .\dnsmasq.leases

python2 /netboot/vDCM_Scripts/update_firmware-4.1.2b.py  --configfile=multiserver_config
grep "ERROR:" update_huu.log