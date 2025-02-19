# Connect to Microsoft Graph (requires Microsoft.Graph PowerShell module)
Disconnect-MgGraph
Connect-MgGraph -Scope "Application.ReadWrite.All" -TenantId 127b7cfb-711b-485b-9c76-2da654a23594

# Get current date for comparison
$currentDate = Get-Date

# Get all applications
$apps = Get-MgApplication


# Filter and remove expired applications
foreach ($app in $apps) {
    $isExpired = $false

    # Check PasswordCredentials (where client secrets are stored)
    if ($null -ne $app.PasswordCredentials) {
        foreach ($credential in $app.PasswordCredentials) {
            if ($null -ne $credential.EndDateTime -and ($credential.EndDateTime -lt $currentDate)) {
                $isExpired = $true
                Write-Host "Expired password found in $($app.DisplayName)"
                break
            }
        }
    }

    # Check ServicePrincipal PasswordCredentials if AppRegistration has no PasswordCredentials
    if (($null -eq $app.PasswordCredentials) -and ($null -ne $app.AppId)) {
        $servicePrincipal = Get-MgServicePrincipal -Filter "appId eq '$($app.AppId)'"
        if ($null -ne $servicePrincipal.PasswordCredentials) {
            foreach ($credential in $servicePrincipal.PasswordCredentials) {
                if ($null -ne $credential.EndDateTime -and ($credential.EndDateTime -lt $currentDate)) {
                    $isExpired = $true
                    Write-Host "Expired password found in ServicePrincipal $($app.DisplayName)"
                    break
                }
            }
        }
    }

    if ($isExpired) {
        Write-Host "Removing expired app registration: $($app.DisplayName)"
        try {
            Remove-MgApplication -ApplicationId $app.Id
            Write-Host "Successfully removed $($app.DisplayName)" -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to remove $($app.DisplayName): $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Skipping $($app.DisplayName)"
    }
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph