using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$emailList = [System.Collections.Generic.List[string]]::new()

if ($name) {
    $items = Get-AzRoleAssignment | Where-Object {$_.RoleDefinitionName -eq "Owner" -and $_.SignInName -ne $null -and $_.SignInName.Contains("#") -ne "True"} | Select -ExpandProperty "SignInName"
    foreach ($item in $items) {
        Write-Host $item
        $emailList.Add($item)
    }
    $emailListJson = ConvertTo-Json $emailList
    Write-Host "Func Output List:" $emailListJson
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $emailList
})
