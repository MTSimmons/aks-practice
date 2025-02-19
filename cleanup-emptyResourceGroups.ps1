
# Login to Azure (uncomment if not already logged in)
# Connect-AzAccount

# Get all resource groups in the subscription
$resourceGroups = Get-AzResourceGroup

foreach ($rg in $resourceGroups) {
    # Get all resources in the resource group
    $resources = Get-AzResource -ResourceGroupName $rg.ResourceGroupName

    # If there are no resources, delete the resource group
    if ($null -eq $resources -or $resources.Count -eq 0) {
        Write-Host "Resource group '$($rg.ResourceGroupName)' is empty. Deleting..."
        
        # Prompt for confirmation before deletion
        $confirm = Read-Host "Are you sure you want to delete the empty resource group '$($rg.ResourceGroupName)'? (Y/N)"
        
        if ($confirm -eq 'Y') {
            Remove-AzResourceGroup -Name $rg.ResourceGroupName -Force
            Write-Host "Resource group '$($rg.ResourceGroupName)' has been deleted."
        }
        else {
            Write-Host "Skipping deletion of resource group '$($rg.ResourceGroupName)'."
        }
    }
    else {
        Write-Host "Resource group '$($rg.ResourceGroupName)' contains $($resources.Count) resources. Skipping."
    }
}

Write-Host "Cleanup completed."