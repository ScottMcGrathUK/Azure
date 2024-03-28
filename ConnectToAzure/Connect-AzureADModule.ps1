<#
.SYNOPSIS
    Function to check if the user is connected to an Azure tenant.
.DESCRIPTION
    This function checks if the user is connected to an Azure tenant. If the user is connected, it
    returns $true, otherwise $false.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Connect-AzureAD {

    try {
        $tenantId = Get-AzureADTenantId
    }
    catch {
        Write-Host 'Not connected`nConnecting to Azure AD...' -ForegroundColor Green
        Connect-AzureAD
    }
    
    if ($null -eq $tenantId) {
        Write-Host 'Not connected to Azure AD.'
    }
    else {
        Write-Host 'Connected to Azure AD.'
    }
}
