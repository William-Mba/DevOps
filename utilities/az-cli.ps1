function Login {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string] $Subscription = "Demo"
    )
    Connect-AzAccount -SubscriptionName $Subscription
}

function Set-Context {
    param (
        [ValidateNotNullOrEmpty()]
        [string] $Subscription = "Demo"
    )
    Set-AzContext -SubscriptionName $Subscription
}

function New-Rg {
    param (
        [Parameter(Mandatory)]
        [string] $Name,
        [ValidateNotNullOrEmpty()]
        [string] $Location = "canadacentral"
    )
    New-AzResourceGroup -Name $Name -Location $Location
}

function New-Credential {
    param (
        [string] $Username,
        [string] $Secret
    )
    $Password = ConvertTo-SecureString $Secret -AsPlainText -Force
    New-Object System.Management.Automation.PSCredential ($Username, $Password)
}

function New-VM {   
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string] $Rg,
        [Parameter(Mandatory)][string] $Name,
        [ValidateNotNullOrEmpty()][string] $Image = 'Win2019Datacenter',
        [Parameter(Mandatory)][pscredential] $Cred,
        [ValidateNotNullOrEmpty()][int[]] $OpenPorts = 3389

    )
    try {
        New-AzVM `
            -ResourceGroupName $Rg `
            -Name $Name `
            -Image $Image `
            -Credential $Cred `
            -OpenPorts $OpenPorts
    }
    catch {
        Write-Warning "Something went wrong while creating Windows VM $Name in resource group $Rg"
    }
}

function Get-PublicIpAddress {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string] $Rg,
        [Parameter(Mandatory)][string] $Vm
    )
    Get-AzPublicIpAddress -Name $Vm -ResourceGroupName $Rg | Select-Object Ip-Address
}

function Remove-Rg {
    [CmdletBinding()]
    param (
        [string[]]$Names
    )
    $Names | Foreach-Object -ThrottleLimit 5 -Parallel {
        #Action that will run in Parallel. Reference the current object via $PSItem and bring in outside variables with $USING:varname
        Remove-AzResourceGroup -Name $PSItem -Force -Verbose
    }
}

function New-RgDeployment {
    [CmdletBinding()]
    param (
        [string] $Name,
        [string] $Rg,
        [string] $TemplateFile,
        [string] $ParameterFile
    )
    # Make sure to set the admin password in the parameters.json file, aroun line 80
    New-AzResourceGroupDeployment -Name $Name -ResourceGroupName $Rg `
        -TemplateFile $TemplateFile -TemplateParameterFile $ParameterFile -Force
}

function New-ACR {
    param (
        $Name,
        $Rg,
        $Sku = "Standard"
    )
    
}