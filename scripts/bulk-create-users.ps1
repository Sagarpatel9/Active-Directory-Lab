# Active Directory Bulk User Creation Script
# Creates users from CSV and places them in department-specific OUs
# Domain: corp.local

$users = Import-Csv -Path C:\Users\labadmin\Desktop\users.csv

foreach ($user in $users) {
    $username = $user.Username
    $exists = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue

    if ($exists) {
        Write-Host "SKIPPED: $username already exists" -ForegroundColor Yellow
    } else {
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@corp.local" `
            -Name "$($user.FirstName) $($user.LastName)" `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -Department $user.Department `
            -Path "OU=$($user.Department),OU=CORP-Users,DC=corp,DC=local" `
            -AccountPassword (ConvertTo-SecureString "Welcome1!" -AsPlainText -Force) `
            -Enabled $true `
            -PasswordNeverExpires $true

        Write-Host "CREATED: $username in $($user.Department)" -ForegroundColor Green
    }
}

Write-Host "`nDone. Total users in CORP-Users:" -ForegroundColor Cyan
(Get-ADUser -Filter * -SearchBase "OU=CORP-Users,DC=corp,DC=local").Count
