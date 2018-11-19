# Edited by Jimmy Chu @ 19Nov2018
# Author: James Evans and Dushyant Gill
# Authenticate with Connect-AzureAD

# Source from below URL
# https://blogs.msdn.microsoft.com/edutech/cloud/script-bulk-assign-users-to-azure-ad-saas-applications/

# Assign one user access to the App - Run Get-RoleID to get the RoleID

# *** CSV for User assignment requires user UPNs populated in a single Column headed "UserPrincipalName" ***
# CSV for Group assignment requires group ObjectIDs populated in a single Column headed ObjectID

# Syntax -File "path to csv" -ObjectID "ObjectID of servicePrincipal" -RoleID "From Get-RoleID unless stated not required"

# Steps to apply this script
# 1/. Install-Module -Name AzureAD
# 2/. Import-Module D:\bulkSaaSAppAssignment.psm1

# Obtain the details of the Application we would like to assign users permissions to
# 
# 3/. Connect-AzureAD
# 4/. Get-AzureADServicePrincipal -SearchString "Apps Name" | fl displayname, objectid

# Obtain information about the RoleID for the assignment operation
# 5/. Get-UserRoleID -UserPrincipalName  -ObjectID 3182-a48e-900a027586f7

# Bulk assign access to Users
# 6/. New-AzureADBulkUserAppAssignment -File "Path to CSV" -ObjectID a119cf6c-1ea1-4447-a160-b195ba36efb7 -RoleID 073e0-15a9aa569e7c

# Bulk assign access to Groups (Optional, if u have group management)
# 7/. Bulk assign access to Groups

# Bulk remove access to Users
# 8/. Remove-AzureADBulkUserAppAssignment -File "Path to CSV" -ObjectID a119cf6c-1ea1-4447-a160-b195ba36efb7

# Bulk remove access to Groups
# 9/. Remove-AzureADBulkGroupAppAssignment -File "Path to CSV" -ObjectID b9c12220-93af-433b-89dc-f441e79f2470


Function Get-UserRoleID {
[CmdletBinding(DefaultParameterSetName='UserPrincipalName')]
Param(
        [Parameter(Mandatory=$true)]
        [String]$UserPrincipalName,

        [Parameter(Mandatory=$true)]
        [String]$ObjectID
)

$RoleID = Get-AzureADUserAppRoleAssignment -ObjectId $UserPrincipalName | Where-Object {$_.ResourceId  -eq $ObjectID} | Select-Object Id

    if ($RoleID.id -ne $null){
        if ($roleID.id.count -gt 1){
        Write-Host 'The RoleID is:' $roleID.id[0]
        }
        else{
            Write-Host 'The RoleID is:' $roleID.id
            }
    }
    if ($RoleID.id -eq ([guid]::Empty).guid){
        Write-Host "RoleID does not neet to be specified for this user-application assignment"
    }
}

Function Get-GroupRoleID {
[CmdletBinding(DefaultParameterSetName='UserPrincipalName')]
Param(
        [Parameter(Mandatory=$true)]
        [String]$Group,

        [Parameter(Mandatory=$true)]
        [String]$ObjectID
)

$RoleID = Get-AzureADGroupAppRoleAssignment -ObjectId $Group | Where-Object {$_.ResourceId  -eq $ObjectID} | Select-Object Id

    if ($RoleID.id -ne $null){
        if ($roleID.id.count -gt 1){
        Write-Host 'The RoleID is:' $roleID.id[0]
        }
        else{
            Write-Host 'The RoleID is:' $roleID.id
            }
    }
    if ($RoleID.id -eq ([guid]::Empty).guid){
        Write-Host "RoleID does not neet to be specified for this user-application assignment"
    }
}

Function New-AzureADBulkUserAppAssignment {
[CmdletBinding(DefaultParameterSetName='File')]
Param(
        [Parameter(Mandatory=$true)]
        [String]$File,

        [Parameter(Mandatory=$true)]
        [String]$ObjectID,

        $RoleID
)

Get-Data $File $ObjectID

if ($RoleID -eq $null){
    $RoleID = "00000000-0000-0000-0000-000000000000"
    }

foreach ($user in $csv){
$user = Get-AzureADUser -ObjectId $user.UserPrincipalName
    Try {
         New-AzureADUserAppRoleAssignment -ObjectId $user.ObjectId -PrincipalId $user.ObjectId -ResourceId $servicePrincipal.ObjectId -Id $RoleID
    }
        Catch{
        Write-Host "User" $user.UserPrincipalName "has already been assigned to" $servicePrincipal.DisplayName -ForegroundColor Yellow
    }
    
}

}

Function Remove-AzureADBulkUserAppAssignment {
[CmdletBinding(DefaultParameterSetName='File')]
Param(
        [Parameter(Mandatory=$true)]
        [String]$File,

        [Parameter(Mandatory=$true)]
        [String]$ObjectID
)

Get-Data $File $ObjectID

foreach ($user in $csv){
$user = Get-AzureADUser -ObjectId $user.UserPrincipalName
$appRole = Get-AzureADUserAppRoleAssignment -ObjectId $user.ObjectId | Where-Object {$_.ResourceId  -eq $servicePrincipal.ObjectId -and $_.PrincipalType -eq  'User'} | Select-Object PrincipalId, ObjectId

    Try{
        Write-host "Removing user" $user.UserPrincipalName"from application" $servicePrincipal.DisplayName -ForegroundColor Green
        Remove-AzureADUserAppRoleAssignment -ObjectId $appRole.PrincipalId -AppRoleAssignmentId $appRole.ObjectId
    }
    Catch{
        Write-Host "* User" $user.UserPrincipalName "is not assigned to" $servicePrincipal.DisplayName -ForegroundColor Yellow
    }
}
}

Function New-AzureADBulkGroupAppAssignment {
[CmdletBinding(DefaultParameterSetName='File')]
Param(
        [Parameter(Mandatory=$true)]
        [String]$File,

        [Parameter(Mandatory=$true)]
        [String]$ObjectID,

        $RoleID
)

Get-Data $File $ObjectID $RoleID

if ($RoleID -eq $null){
    $RoleID = "00000000-0000-0000-0000-000000000000"
    }


foreach ($group in $csv){
    Try {
        New-AzureADGroupAppRoleAssignment -ObjectId $group.ObjectId -PrincipalId $group.ObjectId -ResourceId $servicePrincipal.ObjectId -Id $RoleID
    }
        Catch{
        $group = Get-AzureADGroup -ObjectId $group.ObjectId
        Write-Host "The group:"$group.DisplayName"has already been assigned to" $servicePrincipal.DisplayName -ForegroundColor Yellow
    }

}

}

Function Remove-AzureADBulkGroupAppAssignment {
[CmdletBinding(DefaultParameterSetName='File')]
Param(
        [Parameter(Mandatory=$true)]
        [String]$File,

        [Parameter(Mandatory=$true)]
        [String]$ObjectID
)

Get-Data $File $ObjectID

foreach ($group in $csv){
$group = Get-AzureADGroup -ObjectId $group.ObjectId
$appRole = Get-AzureADGroupAppRoleAssignment -ObjectId $group.ObjectId | Where-Object {$_.ResourceId  -eq $servicePrincipal.ObjectId -and $_.PrincipalType -eq  'Group'} | Select-Object PrincipalId, ObjectId
    Try{
        Write-host "Removing group" $group.DisplayName"from application" $servicePrincipal.DisplayName -ForegroundColor Green
        Remove-AzureADGroupAppRoleAssignment -ObjectId $appRole.PrincipalId -AppRoleAssignmentId $appRole.ObjectId
    }
    Catch{
        Write-Host "The group:" $group.DisplayName "is not assigned to" $servicePrincipal.DisplayName -ForegroundColor Yellow
    }
}

}

Function Get-Data($File, $ObjectID){
$script:csv = Import-Csv $File
$script:servicePrincipal = Get-AzureADServicePrincipal -ObjectId $ObjectID
}