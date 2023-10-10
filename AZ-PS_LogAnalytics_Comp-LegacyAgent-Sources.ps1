# AZ-PS_LogAnalytics_Comp-LegacyAgent-Sources

# RG To Variable:
$RG = (Get-AZResourceGroup -ResourceGroupName <YOUR-RG-NAME>).ResourceGroupName

# Log Analytics Space to Variable:
$LA = (Get-AZOperationalInsightsWorkspace -ResourceGroupName $RG).ResourceID

# KQL Query to Variable (all Comps w/ Legacy LogAnalytics Agent Installed):
$query = "Heartbeat | where OSType == 'Windows' | where Category != 'Azure Monitor Agent' | summarize arg_max(TimeGenerated, *) by SourceComputerId | sort by Computer | render table"

# Invoke Log Analytics KQL Query:
$AZLAComps = Invoke-AZOperationalInsightsQuery -WorkspaceID $LA -Query $query

# Generate Query Results - Full:
$AZLAComps.Results

# Generate Query Results - Pertinent Info:
$AZLAComps.Results | Sort Computer | FT Computer,ComputerIP,OSType,Version,ComputerEnvironment,TimeGenerated
