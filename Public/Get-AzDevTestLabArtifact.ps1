function Get-AzDevTestLabArtifact {
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
		[string]$SourceName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ResourceGroupName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ArmApiVersion = '2016-05-15'
	)

	$ErrorActionPreference = 'Stop'

	try {
		$getArtParams = @{
			ResourceGroupName = $ResourceGroupName
			ResourceType      = 'Microsoft.DevTestLab/labs/artifactSources/artifacts'
			ResourceName      = "$LabName/$SourceName"
			ApiVersion        = $ArmApiVersion
		}

		$whereFilter = { '*' }
		if ($PSBoundParameters.ContainsKey('Name')) {
			$whereFilter = { $_.Name -eq $Name }
		}
		Get-AzResource @getArtParams | Where-Object -FilterScript $whereFilter
		
	} catch {
		throw $_
	}
}

