Import-Module ActiveDirectory
$ESC = [char]27

# Prompt for job titles
$jobTitle1 = Read-Host -Prompt "Job Title 1"
$jobTitle2 = Read-Host -Prompt "Job Title 2"

# Create a function to get users with the mentioned job titles
function Get-ADUsersByJobTitle {
    param (
        [string]$jobTitle
    )
    try {
        $users = Get-ADUser -Filter {title -eq $jobTitle -and Enabled -eq $true} -Properties title
        return $users
    } catch {
        Write-Host "Error fetching users for job title: $jobTitle. $_"
        return @()  # Return an empty array if an error occurs
    }
}

# Get users for the two job titles
$usersWithJobTitle1 = Get-ADUsersByJobTitle -jobTitle $jobTitle1
$usersWithJobTitle2 = Get-ADUsersByJobTitle -jobTitle $jobTitle2

# Get the counts
$countJobTitle1 = $usersWithJobTitle1.Count
$countJobTitle2 = $usersWithJobTitle2.Count

# Print results
Write-Host "------------------------------------"
Write-Host "$($ESC)[92mComparison of Users by Job Title$($ESC)[0m"
Write-Host "`nJob Title 1 $($ESC)[96m($jobTitle1): $countJobTitle1 users$($ESC)[0m"
Write-Host "`nJob Title 2 $($ESC)[96m($jobTitle2): $countJobTitle2 users$($ESC)[0m"
Write-Host "------------------------------------"
