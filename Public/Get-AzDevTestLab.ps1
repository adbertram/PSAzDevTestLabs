function Get-AzDevTestLab {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$SubscriptionId,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ResourceGroupName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ArmApiVersion = '2016-05-15'
	)

	$ErrorActionPreference = 'Stop'

	try {
		$resourceId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.DevTestLab/labs"
		if ($PSBoundParameters.ContainsKey('LabName')) {
			$resourceId += "/$LabName"
		}
		$lab = Get-AzResource -ResourceId $resourceId -ApiVersion $ArmApiVersion
		[pscustomobject]@{
			SubscriptionId    = $SubscriptionId
			ResourceGroupName = $lab.ResourceGroupName
			Name              = $lab.Name
			ResourceType      = $lab.ResourceType
			ResourceId        = $lab.ResourceId
			Location          = $lab.Location
		}
	} catch {
		if ($_.Exception.Message -ne "The Resource 'Microsoft.DevTestLab/labs/$LabName' under resource group '$ResourceGroupName' was not found.") {
			throw $_
		}
	}
}