# Azure Basic Environment

# Set Variables:
$RG = 'AZ-PS1'
$Loc = 'WestUS'
$VNetName = 'AZ-PS-VNet'


# Create RG:
New-AzResourceGroup -Name $RG -Location $Loc

# Create VNet:
$VNet = New-AZVirtualNetwork -ResourceGroupName $RG -Location $Loc -Name $VNetName -AddressPrefix 10.0.0.0/16

# Create Subnet:
Add-AZVirtualNetworkSubnetConfig -Name 'AZ-PS-VSubnet' -AddressPrefix 10.0.1.0/24 -VirtualNetwork $VNet

# Associate Subnet to VNet:
$VNet | Set-AZVirtualNetwork

# Create NetSec Rule:
$SecRule = New-AZNetworkSecurityRUleConfig -Name 'AZ-PS-NetRule' -Description 'Allow Unix' -Access Allow -Protocol TCP -Direction Inbound -Priority 101 -SourcePortRange * -SourceAddressPrefix Internet -DestinationAddressPrefix * -DestinationPortRange 22,80

# Create NetSec Group:
New-AZNetworkSecurityGroup -ResourceGroupName $RG -Location $Loc -Name 'AZ-PS-SecGrp' -SecurityRules $SecRule

# Create VM w/ Assigned Networking:
New-AZVM -Name 'AZ-PS-VM1' -ResourceGroupName $RG -Location $Loc -Size 'Standard_B1ms' -Credential (Get-Credential) -Image UbuntuLTS -OpenPorts 22,80 -VirtualNetworkName $VNetName -SubnetName 'AZ-PS-VSubnet' -SecurityGroupName 'AZ-PS-SecGrp' -PublicIPAddressName 'AZ-PS-IP'
