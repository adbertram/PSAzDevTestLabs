function New-AzDevTestLabUser {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DisplayName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$LabName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$SubscriptionId,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ResourceGroupName
	)

	$ErrorActionPreference = 'Stop'

	try {
		# Retrieve the user object
		$adObject = Get-AzADUser -DisplayName $DisplayName

		# Create the role assignment. 
		$labId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.DevTestLab/labs/$labName"
		$null = New-AzRoleAssignment -ObjectId $adObject.Id -RoleDefinitionName 'DevTest Labs User' -Scope $labId
	} catch {
		throw $_
	}
}