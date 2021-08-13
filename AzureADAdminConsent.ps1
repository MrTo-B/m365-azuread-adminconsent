<#

.SYNOPSIS

Disable User Consent in Azure AD for application registration

.DESCRIPTION

.NOTES

Author: Tobias Aniceta
Version: 1.2  
#>


# Check if AzureADPreview is installed.

$AzureADPreview = Get-Module | Where-Object {$_.Name -eq "AzureADPreview"}

if ($null -eq $AzureADPreview)
    {
        Write-Host "Installing AzureADPreview" -ForegroundColor Red
        Get-Module AzureADPreview
        Install-Module AzureADPreview -Scope CurrentUser
        Write-Host "Azure AD Preview is installed" -ForegroundColor Green
    }
else 
    {
        Write-Host "AzureADPreview is already installed, continuing..." -ForegroundColor Green
    }

# Create Mail-enabled Security Group & disable user consent.

Write-Warning -Message "Attempting to launch a browser for authorization code login."
Connect-AzureAD | Out-Null

$customer = Get-AzureADTenantDetail
$GlobalAdmin = (Get-AzureADUser -Searchstring "systraxadmin")
$GlobalAdminEmail = Get-AzureADUser -Searchstring "systraxadmin" | Where-Object {$_.OtherMails -eq "operations@systrax.nl"}
$AADApplications = @{
    "iOS Accounts" = "f8d98a96-0999-43f5-8af3-69971c7bb423"  
    "Gmail" =        "2cee05de-2b8f-45a2-8289-2a06ca32c4c8"
}

Write-Host "Connected to tenant $($customer.DisplayName), checking e-mail setting for Global Administrator"
if ($GlobalAdminEmail)
{
        Write-Host      "Email is already set, moving on." -ForegroundColor Green
        Write-Output    $($GlobalAdminEmail | Select-Object -Property DisplayName,@{n="E-mail";e={$_.OtherMails}})
}
else {
    Write-Host      "Setting e-mailaddress" -ForegroundColor Yellow
    Set-AzureADUser -ObjectId $($GlobalAdmin.ObjectId) -OtherMails "operations@systrax.nl"
    Write-Output    $($GlobalAdminEmail | Select-Object -Property DisplayName,@{n="E-mail";e={$_.OtherMails}})
}

Write-Host "Setting Authorization Policy"
    Set-AzureADMSAuthorizationPolicy -Id "authorizationPolicy" -PermissionGrantPolicyIdsAssignedToDefaultUserRole @() | Out-Null

foreach ($Key in $AADApplications.Keys) {
    if (-not(Get-AzureADServicePrincipal -Filter "AppId eq '$($AADApplications.$Key)'")) {
        Write-Host -ForegroundColor Yellow "Application $Key not registered yet, use following URL to activate: https://login.microsoftonline.com/$($customer.ObjectId)/adminconsent?client_id=$($AADApplications.$Key)"
    }
    else {
        Write-Host "Application $($Key) already registered." -ForegroundColor Green
    }
}