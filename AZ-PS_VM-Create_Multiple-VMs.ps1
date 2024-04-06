# AZ PS - Create VM v3 - Multiple AZ Cloud VMs

# Set Initial Variables:
$RG='Demo-RG'
$Location='WestUS2'
$VNetName='Demo-VNet'

# Create Resource Group:
New-AZResourceGroup -Name $RG -Location $Location

# Create Virtual Network:
$VirtualNetwork = New-AZVirtualNetwork -ResourceGroupName $RG -Location $Location -Name $VNetName -AddressPrefix 10.1.0.0/16

# Set VirtualNetwork Variable:
$VNet = Get-AZVirtualNetwork -ResourceGroup $RG -Name $VNetName  

# Create Subnet:
Add-AZVirtualNetworkSubnetConfig -Name Subnet1 -AddressPrefix 10.1.0.0/24 -VirtualNetwork $VNet

# Associate Subnet to Virtual Network:
$VNet | Set-AZVirtualNetwork 

# Set VNet Subnet Variable:
$Subnet = (Get-AZVirtualNetworkSubnetConfig -VirtualNetwork $VNet).Name

# VM Admin Creds to Variable:
$adminCredential = Get-Credential -Message "Enter UN / PW for VM admin user"

# Create Multiple VMs - ( 3 VMs Here ):
For ($i = 1; $i -le 3; $i++)
{
    $VMName = "Demo-VM" + $i
    Write-Host "Creating VM: " $VMName
    New-AZVM -ResourceGroupName $RG -Name $VMName -Credential $adminCredential -Image Ubuntu2204 -Size Standard_DS1_v2 -VirtualNetworkName $VNet -SubnetName $Subnet 
}
