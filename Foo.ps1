# /netboot/vDCM_Scripts

Import-module Cisco.imc

$user = "admin"
$ImpPass = Get-Content ./CIMC_Pass
$password = ConvertTo-SecureString 'Ch@rt3r!' -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$password)

$DHCP_Hosts = import-csv ./dnsmasq.leases -Header date,status,IP,MAC,hostname

ForEach ($D_Host in $DHCP_Hosts) {

    Write-Output "Connecting to $($D_Host.IP)"
    $handle = Connect-Imc $D_Host.IP $Imccred
    If ( $handle -ne $null ) {

        $computerRackUnit = get-imcrackunit
        $SerialNumber = $computerRackUnit.Serial
        $SNArray=@()
        import-csv ./sysdata.txt | ForEach-Object { $SNArray += $_.sn }

        ForEach ($Serial in $SNArray) {
            If ($Serial -eq $SerialNumber) {
             Write-Output "Matched $($Serial)"
            }
        }

    Get-ImcRackUnit | Set-ImcRackUnit -AdminPower cycle-immediate -Force

    Get-Content ./NIHUU/multiserver_config | select-string -pattern $D_Host.IP -notmatch | Out-File ./NIHUU/multiserver_config.new
    Add-Content ./NIHUU/multiserver_config.new "address=$($D_Host.IP), user=Admin, password=$($ImpPass), imagefile=ucs-c220m5-huu-4.1.1d.iso"
    Add-Content ./NIHUU/multiserver_config.new ""
    Remove-Item ./NIHUU/multiserver_config
    Rename-Item ./NIHUU/multiserver_config.new multiserver_config
    Disconnect-Imc
    }
}

get-content ./dnsmasq.leases | select-string -pattern $D_Host.IP -notmatch | Out-File ./dnsmasq.leases.new
Remove-Item ./dnsmasq.leases
Rename-Item ./dnsmasq.leases.new ./dnsmasq.leases
