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

# Public IP to Variable:
$IP = Invoke-RestMethod -URI https://ipinfo.io/ip

# Allow RDP from on-Prem Only - Sec Rule:
$SecRule = New-AZNetworkSecurityRuleConfig -Name 'AZ-PS-NetRule' -Description 'Allow RDP' -Access Allow -Protocol TCP -Direction Inbound -Priority 101 -SourcePortRange * -SourceAddressPrefix $IP -DestinationAddressPrefix * -DestinationPortRange 3389

# Create NSG:
New-AZNetworkSecurityGroup -ResourceGroupName $RG -Location $Loc -Name 'AZ-PS-SecGrp' -SecurityRules $SecRule

# Create VM w/ Assigned Networking:
New-AZVM -Name 'AZ-PS-VM1' -ResourceGroupName $RG -Location $Loc -Size 'Standard_B1ms' -Credential (Get-Credential) -Image win2019DataCenter -VirtualNetworkName $VNetName -SubnetName 'AZ-PS-VSubnet' -SecurityGroupName 'AZ-PS-SecGrp' -PublicIPAddressName 'AZ-PS-IP' 
