function Install-AzDevTestLabArtifact {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$VmName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$LabName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$SourceName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$SubscriptionId,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ResourceGroupName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[hashtable]$Parameters, ## {name=name;value=val}

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$RepositoryName = 'Public Repo',

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ArmApiVersion = '2016-05-15'
	)

	$ErrorActionPreference = 'Stop'

	try {
		# Find the virtual machine in Azure
		$vMId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.DevTestLab/labs/$LabName/virtualmachines/$VmName"
		$vm = Get-AzResource -ResourceId $vMId

		# Generate the artifact id
		$artifactId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.DevTestLab/labs/$LabName/artifactSources/$SourceName/artifacts/$Name"

		$artifactParameters = @($Parameters)

		$prop = @{
			artifacts = @(
				@{
					artifactId = $artifactId
					parameters = $artifactParameters
				}
			)
		}

		# Apply the artifact by name to the virtual machine
		$status = Invoke-AzResourceAction -Parameters $prop -ResourceId $vm.ResourceId -Action 'applyArtifacts' -ApiVersion $ArmApiVersion -Force
		if ($status.Status -ne 'Succeeded') {
			throw $status
		}
	} catch {
		throw $_
	}
}