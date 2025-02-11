# Script Name: List_Users_Job_Title.ps1
# Description: List all users with the specified Job Title in AD
# Version: 1.1
# Date: 2025-2-11
# Prerequisite: RSAT

Import-Module ActiveDirectory
$ESC = [char]27

$jobTitle = Read-Host -Prompt "Enter the Job Title"

$domains = @("example.domain.com", "example2.domain.com")

# Create the function that will count all enabled users with a specific job title for a specific domain
function Get-ADUsersCountByJobTitle {
    param (
        [string]$jobTitle,
        [string]$domain
    )
    try {
        # Query users from each domain
        $users = Get-ADUser -Filter {title -eq $jobTitle} -Server $domain -Properties title, Enabled
        # Filter out disabled users and count the enabled ones
        $enabledUsersCount = ($users | Where-Object { $_.Enabled -eq $true }).Count
        return $enabledUsersCount
    } catch {
        Write-Host "Error fetching users for job title: $jobTitle in domain: $domain. $_"
        return 0
    }
}

# Repeat for each domain
foreach ($domain in $domains) {
    Write-Host "$($ESC)[92mSearching in Domain: $domain$($ESC)[0m"
    $enabledUsersCount = Get-ADUsersCountByJobTitle -jobTitle $jobTitle -domain $domain

    # Print the count of users with the Job Title
    Write-Host "Enabled Users with Job Title '$jobTitle' in: $domain"
    Write-Host "$($ESC)[96m$enabledUsersCount users found$($ESC)[0m"
}
