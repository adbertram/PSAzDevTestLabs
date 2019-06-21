function Remove-AzDevTestLabVm {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[string]$LabName,

		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[string]$SubscriptionId,

		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[string]$ResourceGroupName
	)

	begin {
		$ErrorActionPreference = 'Stop'
	}
	process {
		try {
			## Find the lab VM
			$labVm = Get-AzDevTestLabVm -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName -LabName $LabName -Name $Name

			$labVm | Remove-AzResource -Force
		} catch {
			throw $_
		}
	}
}