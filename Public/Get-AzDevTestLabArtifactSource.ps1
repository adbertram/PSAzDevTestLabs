function Get-AzDevTestLabArtifactSource {
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$LabName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ResourceGroupName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ArmApiVersion = '2016-05-15'
	)

	$ErrorActionPreference = 'Stop'

	try {
		
		$getRepoParams = @{
			ResourceGroupName = $ResourceGroupName
			ResourceType      = 'Microsoft.DevTestLab/labs/artifactsources'
			ResourceName      = $LabName
			ApiVersion        = $ArmApiVersion

		}
		Get-AzResource @getRepoParams | Where-Object { $_.Name -eq $Name }

		$whereFilter = { '*' }
		if ($PSBoundParameters.ContainsKey('Name')) {
			$whereFilter = { $_.Name -eq $Name }
		}
		Get-AzResource @getArtParams | Where-Object -FilterScript $whereFilter
		
	} catch {
		throw $_
	}
}

