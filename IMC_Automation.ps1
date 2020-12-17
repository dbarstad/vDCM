Import-module Cisco.imc

$cifsuser = "dbarstad"
$cifspassword = ConvertTo-SecureString 'Dagwood1!' -AsPlainText -Force
$cifscred = New-Object System.Management.Automation.PSCredential($cifsuser,$cifspassword)

$user = "admin"
$password = ConvertTo-SecureString 'Ch@rt3r!' -AsPlainText -Force
$Imccred = New-Object System.Management.Automation.PSCredential($user,$password)

$ftpuser = "anonymous"
$ftppassword = ConvertTo-SecureString 'foo@charter.com' -AsPlainText -Force
$ftpcred = New-Object System.Management.Automation.PSCredential($ftpuser,$ftppassword)

$handle = Connect-Imc 10.177.250.140 $Imccred

Get-ImcFirmwareUpdatable -Type blade-controller | Set-ImcFirmwareUpdatable -AdminState trigger -Type blade-controller -Protocol ftp -RemoteServer "10.177.250.91" -RemotePath "/c220m5/cimc/cimc.bin" -RemoteCredential $ftpcred -Force

<#

Get-ImcStatus -Imc $handle


Get-ImcFirmwareUpdatable -Type blade-controller | Set-ImcFirmwareUpdatable -AdminState trigger -Type blade-controller -Protocol ftp -RemoteServer "10.65.183.111" -RemotePath "/UcseBin/UCSE_CIMC_2.3.1.bin"-RemoteCredential $cred-Force


Set-ImcHuuFirmwareUpdater -AdminState trigger -MapType ftp -RemoteIp 10.177.250.140 -RemoteCredential $ftpcred -RemoteShare "/c220m5/ucs-c220m5-huu-4.1.1d.iso" -StopOnError yes -TimeOut 60 -UpdateComponent All -VerifyUpdate no -force -Xml



Get-ImcHuuFirmwareUpdater -AdminState trigger -MapType nfs -RemoteIp 10.177.250.140 -RemoteCredential $ftpcred -RemoteShare "/c220m5/ucs-c220m5-huu-4.1.1d.iso" -StopOnError Yes -TimeOut 60 -UpdateType immediate  -VerifyUpdate No -force

Get-ImcHuuFirmwareUpdater -AdminState trigger -CimcSecureBoot No -CmcSecureBoot No -Imc 10.177.250.140 -MapType nfs -Password Ch@rt3r! -RemoteIp 10.177.250.140 -RemoteSharePath /c220m5/ucs-c220m5-huu-4.1.1d.iso -SkipMemoryTest Enabled -StopOnError No -TimeOut 60 -UpdateType immediate -Username admin -VerifyUpdate No


Set-ImcHuuFirmwareUpdater -AdminState trigger -MapType cifs -RemoteCredential $cifscred -RemoteIp 10.177.250.91 -RemoteShare /c220m5/ucs-c220m5-huu-4.1.1d.iso -Force -StopOnError No -TimeOut 60 -VerifyUpdate No

Set-ImcHuuFirmwareUpdater -AdminState trigger -MapType cifs -RemoteCredential $cifscred -RemoteIp 10.177.250.91 -RemoteShare /c220m5/ucs-c220m5-huu-4.1.1d.iso -UpdateComponent blade-bios -Force -StopOnError No -TimeOut 60 -VerifyUpdate No



Set-ImcHuuFirmwareUpdater -AdminState trigger -MapType cifs -RemoteCredential $cifscred -RemoteIp 10.177.250.91 -RemoteShare /c220m5/ucs-c220m5-huu-4.1.1d.iso -UpdateComponent All -Force -StopOnError No -TimeOut 60 -VerifyUpdate No



Set-ImcHuuFirmwareUpdater -AdminState trigger -MapType www -RemoteCredential $cifscred -RemoteIp 10.177.250.91 -RemoteShare /c220m5/ucs-c220m5-huu-4.1.1d.iso -UpdateComponent blade-bios -Force -StopOnError No -TimeOut 60 -VerifyUpdate No


#>