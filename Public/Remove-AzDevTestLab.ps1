function Remove-AzDevTestLab {
	[OutputType('void')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
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
		[string]$ArmApiVersion = '2016-05-15',

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$Force
	)

	$ErrorActionPreference = 'Stop'

	try {
		$vms = Get-AzDevTestLabVm -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName -LabName $Name
		if ($vms -and -not $Force.IsPresent) {
			throw 'VMs still exist in lab. Remove them with Remove-AzDevTestLabVm or use the -Force parameter.'
		} elseif ($vms) {
			Write-Verbose -Message "$(@($vms).Count) VM(s) found in lab. Removing..."
			$null = $vms | Remove-AzDevTestLabVm
		}
		Write-Verbose -Message 'Removing lab...'
		$lab = Get-AzDevTestLab -Name $Name -SubscriptionId $SubscriptionId -ResourceGroupNam $ResourceGroupName
		$null = Get-AzResource -ResourceId $lab.ResourceId -ApiVersion $ArmApiVersion | Remove-AzResource -Force
	} catch {
		throw $_
	}
}