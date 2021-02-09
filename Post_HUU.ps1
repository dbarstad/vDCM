# Pull successful HUU hosts from logs and push configs for vDCM/BIOS/CIMC

$Log_Search_Text = "HUU Firmware Update Successful on server with CIMC"

$huu_success =  Get-Content update_huu.log | Where-Object {$_ -match $Log_Search_Text}


Foreach ($Line in $huu_success) {
    $IP = ($Line | Select-String -Pattern '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b').Matches.Value
    $IP
    $Successful_IPs += $IP
}

(Get-Content -Path update_huu.log) -replace $Log_Search_Text, "CIMC updated" | Out-File update_huu.log
