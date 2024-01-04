# AZ PS - NSG List All

# List All NSGs + NSG Rules & Associated NICs + Subnets & Output to CSV

$nsgs = Get-AzNetworkSecurityGroup

    Foreach ($nsg in $nsgs) {
        $nsgRules = $nsg.SecurityRules

        foreach ($nsgRule in $nsgRules) {
            $nsgRule | 
			Select-Object @{Name='ResourceGroupName';Expression={$nsg.ResourceGroupName}},
                @{Name='NetworkSecurityGroupName';e={$nsg.Name}},
                Name,Description,Priority,
                @{Name='SourceAddressPrefix';Expression={[string]::join(",", ($_.SourceAddressPrefix))}},
                @{Name='SourcePortRange';Expression={[string]::join(",", ($_.SourcePortRange))}},
                @{Name='DestinationAddressPrefix';Expression={[string]::join(",", ($_.DestinationAddressPrefix))}},
                @{Name='DestinationPortRange';Expression={[string]::join(",", ($_.DestinationPortRange))}},
                Protocol,Access,Direction,
                @{Name='NetworkInterfaceName';Expression={$nsg.NetworkInterfaces.Id.Split('/')[-1]}},
                @{Name='SubnetName';Expression={$nsg.Subnets.Id.Split('/')[-1]}} |
                    Export-Csv "C:\_IT-Temp\NSG_Rules_$(Get-Date -F yyyy-MM-dd).csv" -NoTypeInformation -Encoding ASCII -Append        
    }
}
