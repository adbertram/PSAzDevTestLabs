function New-AzDevTestLab {
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

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$VirtualNetworkName
	)

	$ErrorActionPreference = 'Stop'

	try {
		$labArm = @{
			'$schema'        = "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"
			"contentVersion" = "1.0.0.0"
			"resources"      = @(
				@{
					"apiVersion" = "2018-10-15-preview"
					"type"       = "Microsoft.DevTestLab/labs"
					"name"       = "$Name"
					"location"   = "[resourceGroup().location]"
					"resources"  = @(
						@{
							"apiVersion" = "2018-10-15-preview"
							"name"       = $VirtualNetworkName
							"type"       = "virtualNetworks"
							"dependsOn"  = @(
								"[resourceId('Microsoft.DevTestLab/labs','$Name')]"
							)
						}
					)
				}
			)
			"outputs"        = @{
				"labId" = @{
					"type"  = "string"
					"value" = "[resourceId('Microsoft.DevTestLab/labs','$Name')]"
				}
			}
		}

		$deploymentName = "$((New-Guid).Guid)-AzDevTestLab-NewLab"
		$null = New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $ResourceGroupName -TemplateObject $labArm
	} catch {
		throw $_
	} finally {
		$null = Get-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $ResourceGroupName | Remove-AzResourceGroupDeployment
	}
}