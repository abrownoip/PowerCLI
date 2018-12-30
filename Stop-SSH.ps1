$vmhost = Read-Host "What vmhost?"

Get-VMHostService -VMHost $vmhost | Where-Object -Property Key -EQ TSM-SSH | Stop-VMHostService