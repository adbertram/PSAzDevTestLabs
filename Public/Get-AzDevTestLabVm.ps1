function Get-AzDevTestLabVm {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[string]$SubscriptionId,

		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[string]$ResourceGroupName,

		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[string]$LabName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ArmApiVersion = '2016-05-15'
		
	)

	$ErrorActionPreference = 'Stop'

	try {
		$id = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.DevTestLab/labs/$LabName/virtualmachines"
		if ($PSBoundParameters.ContainsKey('VmName')) {
			$id += "/$Name"
		}
		$vm = Get-AzResource -ResourceId $id -ApiVersion $ArmApiVersion
		[pscustomobject]@{
			SubscriptionId    = $SubscriptionId
			ResourceGroupName = $lab.ResourceGroupName
			LabName           = $LabName
			Name              = $vm.Name
			ResourceType      = $vm.ResourceType
			ResourceId        = $vm.ResourceId
		}
	} catch {
		if ($_.Exception.Message -ne "The Resource 'Microsoft.DevTestLab/labs/TestLab/virtualMachines/$Name' under resource group '$ResourceGroupName' was not found.") {
			throw $_
		}
	}

}