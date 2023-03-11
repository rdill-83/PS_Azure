# AZ PS - Load Balancer Create Config

<# GitHub Scripts: 
git clone https://github.com/MicrosoftDocs/mslearn-improve-app-scalability-resiliency-with-load-balancer.git
cd mslearn-improve-app-scalability-resiliency-with-load-balancer
bash create-high-availability-vm-with-sets.sh $RG
#>

$RG = (Get-AZResourceGroup).ResourceGroupName
$Loc = (Get-AZResourceGroup).Location

# create a new public IP address
$PublicIP = New-AZPublicIPAddress -ResourceGroupName $RG -Location $Loc -AllocationMethod Static -Name 'myPublicIP'


# Create a front-end IP
$FrontEndIP = New-AZLoadBalancerFrontEndIPConfig -Name 'myFrontEnd' -PublicIPAddress $PublicIP

# Create Load Balancer Section:
# Create Backend Pool - (Create a back-end address pool by running the New-AzLoadBalancerBackendAddressPoolConfig cmdlet. You attach the VMs to this back-end pool in the final steps.) :
$backendPool = New-AZLoadBalancerBackEndAddressPoolConfig -Name 'myBackendPool'

# Create Health Probe - (The health probe dynamically adds or removes VMs from the load balancer rotation based on their response to health checks):
$probe = New-AZLoadBalancerProbeConfig -Name 'myHealthProbe' -Protocol Http -Port 80 -IntervalInSeconds 5 -ProbeCount 2 -RequestPath "/"

# Load Balancer Rule - (define the front-end IP configuration for the incoming traffic and the back-end IP pool to receive the traffic, along with the required source and destination port):
$lbRule = New-AZLoadBalancerRuleConfig -name "myLoadBalancerRule" -FrontEndIPConfiguration $FrontEndIP -BackEndAddressPool $backendPool -Protocol TCP -FrontEndPort 80 -BackEndPort 80 -Probe $probe

# Create Load Balancer:
$LB = New-AZLoadBalancer -ResourceGroupName $RG -Name 'myLoadBalancer' -Location $Loc -FrontendIpConfiguration $FrontEndIP -BackEndAddressPool $backendPool -Probe $probe -LoadBalancingRule $LBRule 


# Connect VMs to Backend Pool:
$nic1 = Get-AZNetworkInterface -ResourceGroupName $RG -Name 'webNIC1'
$nic2 = Get-AZNetworkInterface -ResourceGroupName $RG -Name 'webNIC2'

$nic1.IpConfigurations[0].LoadBalancerBackEndAddressPools = $backendPool
$nic2.IPConfigurations[0].LoadBalancerBackEndAddressPools = $backendPool

Set-AZNetworkInterface -NetworkInterface $nic1 -AsJob
Set-AZNetworkInterface -NetworkInterface $nic2 -AsJob 


# Get Load Balancer Public IP:
Write-Host http://$($(Get-AZPublicIPAddress -ResourceGroupName $RG -Name "myPublicIP").IpAddress)


# Test Config by Browsing to Above Output