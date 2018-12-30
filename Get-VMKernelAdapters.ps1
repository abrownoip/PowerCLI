$vmhost = Read-Host "What vmhost?"

Get-VMHostNetworkAdapter -VMHost $vmhost | Where-Object -Property Name -Match vmk | Select-Object -Property *
