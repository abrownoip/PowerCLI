### REVISING/EDITING DON'T RUN ###

### Algorithm ###
# Import required modules
# Declare and assign variables needed in global scope
# Connect to the old and new vCenter Servers
# Grab all the old datacenters

#Functions

### Variable declaration and assignment ###
$oldViServer = Read-Host "Enter the old vCenter Server: "
$newViServer = Read-host "Enter the new vCenter Server: "
$oldDatacenters
$newDatacenters

### Get datacenters that haven't been migrated ###

$oldDatacenters = Get-Datacenter -Server $oldViServer
$oldDatacenterNames = $oldDatacenters.Name

### Making Switches ###
foreach($datacenter in $datacenters)
{
    $siteCode = $datacenter.Split("-")[1]
    $siteCode

    $vdSwitch1 = Get-VDSwitch -Server <server> -Location $datacenter | Where-Object -Property Name -Match "1"
    $vdSwitch2 = Get-VDSwitch -Server <server> -Location $datacenter | Where-Object -Property Name -Match "2"
    Set-VDSwitch -Server <server> -VDSwitch $vdSwitch1 -MaxPorts 500
    Set-VDSwitch -Server <server> -VDSwitch $vdSwitch2 -MaxPorts 500
    
}


$datacenters = (Get-Datacenter -Server <server> | Where-Object {$_.Name -NotMatch "x_" -and $_.Name -notmatch "X" -and $_.Name -notmatch "X"}).Name

### Making VDPortgroups ###
foreach($datacenter in $datacenters)
{
    $vdSwitch1 = Get-VDSwitch -Server <server> -Location $datacenter | Where-Object -Property Name -Match 1
    $vdSwitch2 = Get-VDSwitch -Server <server> -Location $datacenter | Where-Object -Property Name -Match 2

    $vdportgroupmgmt = (Get-VDPortgroup -VDSwitch $vdSwitch1 | Where-Object -Property Name -Match mgmt).Name
    $vdportgroupvm = (Get-VDPortgroup -VDSwitch $vdSwitch2 | Where-Object {$_.Name -Match 'vm' -and $_.NumPorts -eq '128'}).Name
    $vdportgroupvmotion1 = (Get-VDPortgroup -VDSwitch $vdSwitch1 | Where-Object -Property Name -Match vmotion-1 | Select-Object -Property Name).Name
    $vdportgroupvmotion2 = (Get-VDPortgroup -VDSwitch $vdSwitch1 | Where-Object -Property Name -Match vmotion-2 | Select-Object -Property Name).Name

    $vlanidmgmt = (Get-VDPortgroup -VDSwitch $vdSwitch1 | Where-Object -Property Name -Match mgmt).vlanconfiguration.vlanid
    $vlanidvm = (Get-VDPortgroup -VDSwitch $vdSwitch2 | Where-Object {$_.Name -Match 'vm' -and $_.NumPorts -eq '128'}).vlanconfiguration.vlanid
    $vlanidvmotion = (Get-VDPortgroup -VDSwitch $vdSwitch1 | Where-Object -Property Name -Match vmotion).vlanconfiguration.vlanid[0]
    
    Disconnect-VIServer <server>

    New-VDPortgroup -VDSwitch $vdSwitch1.Name -Name $vdportgroupmgmt -NumPorts 128 -VlanId $vlanidmgmt -PortBinding Static -Server <server> -WhatIf
    New-VDPortgroup -VDSwitch $vdSwitch1.Name -Name $vdportgroupvmotion1 -NumPorts 128 -VlanId $vlanidvmotion -PortBinding Static -Server <server> -WhatIf
    New-VDPortgroup -VDSwitch $vdSwitch1.Name -Name $vdportgroupvmotion2 -NumPorts 128 -VlanId $vlanidvmotion -PortBinding Static -Server <server> -WhatIf
    New-VDPortgroup -VDSwitch $vdSwitch2.Name -Name $vdportgroupvm -NumPorts 128 -VlanId $vlanidvm -PortBinding Static -Server <server> -WhatIf
  
}

### From datacenters that haven't been migrated, get the vds ###
Get-Datacenter -Server <server> | Where-Object -Property Name -NotMatch "x_" | Get-VDSwitch


### Get datacenters that haven't been migrated - save to variable ###
$datacenters = Get-Datacenter -Server <server> | Where-Object -Property Name -NotMatch "x_"

foreach($datacenter in $datacenters){Get-VDSwitch -Location $datacenter | Select-Object -Property *}

foreach($datacenter in $datacenters)
{
    $switches = Get-VDSwitch -Location $datacenter

    foreach($switch in $switches)
    {
        Get-VDSwitch $switch | Select-Object -Property LinkDiscoveryProtocol
        
    }
    
}


New-VDSwitch -Link
DiscoveryProtocol

foreach($datacenter in $datacenters)
{
    $vmFolders = Get-Folder -Type VM -Location $datacenter | Where-Object -Property Name -NotLike vm
    foreach($vmFolder in $vmFolders){New-Folder -Name $vmFolder -Location $datacenter -Server <server> -WhatIf}
}
}

$datacenter = Get-Datacenter *fbnv* -Server <server>

$vdswitches = Get-VDSwitch -Location $datacenter -Server <server>

foreach($vdswitch in $vdswitches)
{
    $vdswitch = Get-VDSwitch $vdswitch
    $vdswitch.Name
    $vlanconfiguration = Get-VDPortgroup -VDSwitch $vdswitch | Where-Object -Property Name -NotMatch dvuplinks | Select-Object -Property VlanConfiguration
    $vlanconfiguration
    $vlanid = $vlanconfiguration.VlanConfiguration.VlanId
    $vlanid
}
