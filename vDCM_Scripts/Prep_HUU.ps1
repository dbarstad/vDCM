# Prep_HUU.ps1 -- /netboot/vDCM_Scripts

Get-Content update_huu.log.archive, update_huu.log | Out-File update_huu.log.archive
Remove-Item update_huu.log

Import-module Cisco.imc

$user = "admin"
$defPass = ConvertTo-SecureString "password" -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$defPass)

$DHCP_Hosts = import-csv dnsmasq.leases -Header date,status,IP,MAC,hostname

ForEach ($D_Host in $DHCP_Hosts) {

    If ( $D_Host.status -eq "add" ) {

        $handle = Connect-Imc -Name $D_Host.IP $Imccred

        If ( $? ) {

            (Get-Content multiserver_config) | Select-String -pattern $D_Host.IP -notmatch | Out-File multiserver_config
            Add-Content multiserver_config "address=$($D_Host.IP), user=admin, password=password, imagefile=ucs-c220m5-huu-4.1.1d.iso"
        }
    }
    (Get-Content dnsmasq.leases) | Select-String -pattern $D_Host.IP -notmatch | Out-File dnsmasq.leases
    Disconnect-Imc
}

Get-Content dnsmasq.leases | ? {$_.trim() -ne "" } | Out-File dnsmasq.leases

python2 /netboot/vDCM_Scripts/update_firmware-4.1.2b.py  --configfile=multiserver_config
grep "ERROR:" update_huu.log