# Script Name: Find_User_Info.ps1
# Description: List some basic information on a user. THis was made as a way to quickly learn anything about a user.
# Version: 1.4
# Date: 2024-12-31
# Prerequisite: RSAT, Domain name

Import-Module ActiveDirectory

# Prompt for the users alias
$User = Read-Host -Prompt "Enter the Users Alias"
# Specify Domain Controller (Prerequisite)
# Remove -Server to search the entire directory
$GetInfo = Get-ADUser -Filter {SamAccountName -eq $User} -Server "Your Domain" -Properties *
$ESC = [char]27

# Function to get user details
function GetUserDetails {
    param (
        [string]$User,
        [object]$Info
    )
    # Check if user exists
    if ($Info) {
        # Print user details
        Write-Host "Firstname: $($Info.GivenName)"
        Write-Host "Lastname: $($Info.Surname)"
        Write-Host "$($ESC)[95mLast Logon: $($Info.LastLogonDate)"
        Write-Host "$($ESC)[95mLast Bad Password: $($Info.LastBadPasswordAttempt)"
        Write-Host "$($ESC)[95mPassword Last Set: $($Info.PasswordLastSet)"
        Write-Host "$($ESC)[95mUser Created: $($Info.whenCreated)$($ESC)[0m"
        Write-Host "$($ESC)[93mOffice: $($Info.Office)$($ESC)[0m"
        Write-Host "$($ESC)[93mTelephone Number: $($Info.TelephoneNumber)$($ESC)[0m"
        Write-Host "$($ESC)[93mMobile Number: $($Info.Mobile)$($ESC)[0m"
        Write-Host "Job Title: $($Info.Title)"
        Write-Host "Department: $($Info.Department)"
        Write-Host "E-mail: $($Info.EmailAddress)"
        Write-Host "Address/Street: $($Info.StreetAddress)"
        Write-Host "Description: $($Info.Description)"
        Write-host "$($ESC)[93mMemberOf Groups:$($ESC)[0m"
        $Info.MemberOf | ForEach-Object {
            # Use regex to extract the CN part
            if ($_ -match '^CN=([^,]+),') {
                $matches[1]
            }
        }
    }
}

# Get account Locked, Disabled, or Active status
function CheckStatus {
    param (
        [string]$User,
        [object]$Info
    )
    if ($Info) {
        if ($Info.Enabled -eq $false) {
            Write-Host "$($ESC)[91mAccount Status: Disabled$($ESC)[0m"
        } 
        elseif ($Info.LockedOut -eq $true) {
            Write-Host "$($ESC)[91mAccount Status: Locked$($ESC)[0m"
        } 
        else {
            Write-Host "$($ESC)[96mAccount Status: Active$($ESC)[0m"
        }
    }
    else {
        Write-Host "$($ESC)[91mUser not found.$($ESC)[0m"
    }
    if ($Info) {
        if ($Info.LockedOut -eq $true) {
            Write-Host "$($ESC)[91mLocked = True$($ESC)[0m"
            Write-Host "LockOut Time = $($Info.lockoutTime)"
        } 
        else {
            Write-Host "$($ESC)[96mLocked = False$($ESC)[0m"
        }
    }
    else {
        Write-Host "$($ESC)[91mUser not found.$($ESC)[0m"
    }
}
Write-Host "------------------------------------"
Write-Host "$($ESC)[92mUser Details$($ESC)[0m"
Write-Host "------------------------------------"
GetUserDetails -User $User -Info $GetInfo
Write-Host "-----------------------------"
Write-Host "$($ESC)[92mUser Account Status$($ESC)[0m"
Write-Host "------------------------------------"
CheckStatus -User $User -Info $GetInfo
Write-Host "-----------------------------"
