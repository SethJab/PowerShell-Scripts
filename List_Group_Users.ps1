# Script Name: List_Group_Users.ps1
# Description: List all users in the specified AD group
# Version: 1.0
# Date: 2024-12-30
# Prerequisite: RSAT

Import-Module ActiveDirectory

# Prompt for group name
$GroupName = Read-Host "Group name"

# Check if the group exists
if (-not (Get-ADGroup -Filter {Name -eq $GroupName})) {
    Write-Host "Group '$GroupName' not found." -ForegroundColor Red
    exit
}

# Fetch and list usernames
try {
    $GroupMembers = Get-ADGroupMember -Identity $GroupName -Recursive | Where-Object { $_.objectClass -eq 'user' }

    # Check if users were found
    if ($GroupMembers) {
        Write-Host "`nUsers in group '$GroupName':" -ForegroundColor Green
        $GroupMembers | ForEach-Object {
            $_.Name
        }
    } else {
        Write-Host "No users found in group '$GroupName'." -ForegroundColor Yellow
    }
}
catch {
    Write-Error "An error occurred: $_"
}
