Connect-AzureAD
    
$GraphApplicationId = "00000003-0000-0000-c000-000000000000" # This the ID for the Microsoft Graph API. Please fo not change it
$MSIName = "nzaplpolicyfuncps" # This is the name of the MSI you want to assign the permission to
$PermissionName = "Directory.Read.All" # This is the permission you want to assign to the MSI. Please do not change it

$MSIObject = (Get-AzureADServicePrincipal -Filter "displayName eq '$MSIName'")
Start-Sleep -Seconds 10
$GraphServicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$GraphApplicationId'"
$ApplicationRole = $GraphServicePrincipal.AppRoles | Where-Object { $_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application" }
New-AzureAdServiceAppRoleAssignment -ObjectId $MSIObject.ObjectId -PrincipalId $MSIObject.ObjectId -ResourceId $GraphServicePrincipal.ObjectId -Id $ApplicationRole.Id
