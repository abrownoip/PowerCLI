$vmhost = Read-Host "What vmhost?"

$ip = Read-Host "What IP address?"

$sm = Read-Host "What subnet mask?"

$mtu = Read-Host "What MTU size?"

$vmk = Read-Host "What VMK Adapter?"

Get-VMHostNetworkAdapter -VMHost $vmhost | Where-Object -Property Name -Match $vmk | Set-VMHostNetworkAdapter -IP $ip -SubnetMask $sm -Mtu $mtu -VMotionEnabled $true