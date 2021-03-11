# Prep_HUU.ps1 -- /netboot/vDCM_Scripts

Get-Content update_huu.log.archive, update_huu.log | Out-File update_huu.log.archive
Remove-Item update_huu.log
Copy-Item .\multiserver_config.bak -Destination .\multiserver_config -force

Import-module Cisco.imc

$user = "admin"
$ImpPass = Get-Content ./CIMC_Pass
$defPass = ConvertTo-SecureString "password" -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$defPass)

$DHCP_Hosts = import-csv dnsmasq.leases -Header date,status,IP,MAC,hostname

ForEach ($D_Host in $DHCP_Hosts) {

    If ( $D_Host.hostname -ne "" ) {

        $handle = Connect-Imc -Name $D_Host.IP $Imccred

        If ( $? ) {
            Write-Host "Found: $($D_Host.hostname) on IP $($D_Host.IP)"
            Get-ImcLocalUser  -AccountStatus "active" | Set-ImcLocalUser -Pwd $ImpPass -Force
            (Get-Content multiserver_config) | Select-String -pattern $D_Host.IP -notmatch | Out-File multiserver_config
            Add-Content multiserver_config "address=$($D_Host.IP), user=admin, password=$ImpPass, imagefile=ucs-c220m5-huu-4.1.1d.iso"
        }
    }
    Disconnect-Imc
}

(Get-Content multiserver_config) | ? {$_.trim() -ne "" } | Out-File multiserver_config

python2 /netboot/vDCM_Scripts/update_firmware-4.1.2b.py  --configfile=multiserver_config
grep "ERROR:" update_huu.log