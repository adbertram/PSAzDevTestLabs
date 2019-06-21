function New-AzDevTestLabVm {
	[OutputType('pscustomobject')]
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
		[string]$LabName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$AdminUserName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$AdminPassword,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$VMImageOffer,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$VMImagePublisher,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$VMImageSku,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$VmSize,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$VirtualNetworkName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$OsType = 'Windows',

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ArmApiVersion = '2016-05-15'
	)

	$ErrorActionPreference = 'Stop'

	try {
		$lab = Get-AzDevTestLab -Name $LabName -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName

		$getVnetParams = @{
			ResourceType      = 'Microsoft.DevTestLab/labs/virtualnetworks'
			ResourceGroupName = $lab.ResourceGroupName
			ApiVersion        = $ArmApiVersion
		}
		if ($PSBoundParameters.ContainsKey('VirtualNetworkName')) {
			$getVnetParams.ResourceName = "$LabName/$VirtualNetworkName"
		} else {
			$getVnetParams.ResourceName = $LabName
		}
		$virtualNetwork = @(Get-AzResource @getVnetParams)[0]
		$labSubnetName = $virtualNetwork.properties.allowedSubnets[0].labSubnetName

		$parameters = @{
			"name"       = $Name
			"location"   = $lab.Location
			"properties" = @{
				"labVirtualNetworkId"   = $virtualNetwork.ResourceId
				"labSubnetName"         = $labSubnetName
				"osType"                = $OsType
				"galleryImageReference" = @{
					"offer"     = $VmImageOffer
					"publisher" = $VmImagePublisher
					"sku"       = $VmImageSku
					"osType"    = $OsType
					"version"   = "latest"
				}
				"size"                  = $VmSize
				"userName"              = $AdminUserName
				"password"              = $AdminPassword
			}
		}


		$null = Invoke-AzResourceAction -ResourceId $lab.ResourceId -Action 'createEnvironment' -Parameters $parameters -ApiVersion $ArmApiVersion -Force -Verbose
	} catch {
		if ($_.Exception.Message -ne "The Resource 'Microsoft.DevTestLab/labs/TestLab/virtualMachines/$Name' under resource group '$ResourceGroupName' was not found.") {
			throw $_
		}
	}

}