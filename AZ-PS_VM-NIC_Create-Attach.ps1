# Create VM NIC & Associate w/ VM

### Create Necessary Resources:

# Stock RG Creation:
$RG = "Demo-RG"
$Loc = "westus2"

New-AZResourceGroup -Name $RG -Location $Loc


# Create Public IP:
$IP = @{
    Name = "Demo-PubIP"
    ResourceGroupName = $RG
    Location = $Loc
    AllocationMethod = "Static"
    IPAddressVersion = "IPV4"
}
New-AZPublicIPAddress @IP 

# Public IP to Variable:
$pubIP = @{
    Name = "Demo-PubIP"
    ResourceGroupName = $RG
}

# Create VNet:
$Vnet = @{
    Name = "Demo-Vnet"
    ResourceGroupName = $RG
    Location = $Loc
    AddressPrefix = "10.0.0.0/16"
}
$virtualNetwork = New-AZVirtualNetwork @Vnet

# Create Subnet:
$subnet = @{
    Name = "Demo-Subnet"
    VirtualNetwork = $virtualNetwork
    AddressPrefix = "10.0.0.0/24"
}
$subnetConfig = Add-AZVirtualNetworkSubnetConfig @subnet

$virtualNetwork | Set-AZVirtualNetwork

$subnetName = $Vnet.Subnets[0].Name

# VNet to Variable:
$net = @{
    Name = "Demo-VNet"
    ResourceGroupName = $RG
}
$VNet = Get-AZVirtualNetwork @net

# IP Configuration to Variable:
$IPConf = @{
    Name = "Demo-IP"
    Subnet = $VNet.Subnets[0]
    PrivateIPAddressVersion = "IPV4"
    PublicIPAddress = $pubIP
}
$IPConfig = New-AZNetworkInterfaceIPConfig @IPConf -Primary 

# Create NIC:
$nic = @{
    ResourceGroupName = $RG
    Location = $Loc 
    Name = "Demo-NIC"
    IPConfiguration = $IPConfig 
}
New-AZNetworkInterface @NIC 

# NIC Values to Variables:
$NICName = (Get-AZNetworkInterface -ResourceGroupName $RG -Name $nic.Name).Name
$NICID = (Get-AZNetworkInterface -ResourceGroupName $RG -Name $NICName).ID

# VM Creation:
$VMName = "Demo-VM"
$VM = @{
    ResourceGroupName = $RG 
    Location = $Loc 
    Name = $VMName 
    Image = "ubuntu2204"
    Size = "Standard_DS1_v2"
    Credential = (Get-Credential)
    VirtualNetworkName = $Vnet.Name
    SubnetName = $subnetName
    OpenPorts = "22"
    OSDiskDeleteOption = "Delete "
    NetworkInterfaceDeleteOption = "Delete "
}
New-AZVM @VM


### Add NIC to VM:

# VM to Variable:
$VM = Get-AZVM -ResourceGroupName $RG -Name $VMName

# Stop Target VM:
Stop-AZVM -ResourceGroupName $RG -Name $VM.Name -Force

# Add NIC to VM:
Add-AZVMNetworkInterface -VM $VM -ID $NICID -Primary | Update-AZVM -ResourceGroupName $RG

# Start Target VM:
Start-AZVm -ResourceGroupName $RG -Name $VM.Name -Verbose

# View NIC Info:
Get-AZNetworkInterface -ResourceGroupName $RG -Name $NICName

# View VM NIC Info:
(Get-AZVM -ResourceGroupname $RG -Name $VMName).NetworkProfile.NetworkInterfaces

# Remove Auto Created / Non-Primary NIC:
Remove-AZVMNetworkInterface -ID ((Get-AZVM -ResourceGroupname $RG -Name $VMName).NetworkProfile.NetworkInterfaces | Where {$_.Primary -eq $false}).ID -VM $VM | Update-AZVM
