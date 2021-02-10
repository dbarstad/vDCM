# /netboot/vDCM_Scripts

$SNArray=import-csv ./sysdata.txt

ForEach ($Serial in $SNArray) {
        
        
        Write-Host "-ExtGw $($Serial.cgw)"
        Write-Host "-ExtIp $($Serial.cip)"
        Write-Host "-ExtMask $($Serial.cnm)"
}
