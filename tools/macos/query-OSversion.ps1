function Show-Menu
{
    param (
        [string]$Title = 'OS Version Query Power Engine 2000 Type-r Limited Edition 2.1'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' for 1607"
    Write-Host "2: Press '2' for 1703"
    Write-Host "3: Press '3' for 1709"
    Write-Host "4: Press '4' for 1803"
    Write-Host "5: Press '5' for 1809"
    Write-Host "6: Press '6' for 1903"
    Write-Host "7: Press '7' for 1909"
    Write-Host "8: Press '8' for All Windows"
    Write-Host "Q: Press 'Q' to quit."
}

do
{
Show-Menu -Title 'OS Version Query Power Engine 2000 Type-r Limited Edition 2.1'
$selection = Read-Host "Please make a selection for OS Version"
switch ($selection)
 {
     '1' {
         'You have chosen 1607'
         Get-ADComputer -LDAPFilter "(OperatingSystemVersion=*14393*)" -SearchBase "OU=Desktop Computers,DC=influentials,DC=local" -properties OperatingSystemVersion | Format-Table Name,OperatingSystemVersion -wrap -auto
     } '2' {
         'You have chosen 1703'
         Get-ADComputer -LDAPFilter "(OperatingSystemVersion=*15063*)" -SearchBase "OU=Desktop Computers,DC=influentials,DC=local" -properties OperatingSystemVersion | Format-Table Name,OperatingSystemVersion -wrap -auto
     } '3' {
         'You have chosen 1709'
         Get-ADComputer -LDAPFilter "(OperatingSystemVersion=*16299*)" -SearchBase "OU=Desktop Computers,DC=influentials,DC=local" -properties OperatingSystemVersion | Format-Table Name,OperatingSystemVersion -wrap -auto
     } '4' {
         'You have chosen 1803'
         Get-ADComputer -LDAPFilter "(OperatingSystemVersion=*17134*)" -SearchBase "OU=Desktop Computers,DC=influentials,DC=local" -properties OperatingSystemVersion | Format-Table Name,OperatingSystemVersion -wrap -auto
     } '5' {
         'You have chosen 1809'
         Get-ADComputer -LDAPFilter "(OperatingSystemVersion=*17763*)" -SearchBase "OU=Desktop Computers,DC=influentials,DC=local" -properties OperatingSystemVersion | Format-Table Name,OperatingSystemVersion -wrap -auto
     } '6' {
         'You have chosen 1903'
         Get-ADComputer -LDAPFilter "(OperatingSystemVersion=*18362*)" -SearchBase "OU=Desktop Computers,DC=influentials,DC=local" -properties OperatingSystemVersion | Format-Table Name,OperatingSystemVersion -wrap -auto
     } '7' {
         'You have chosen 1909'
         Get-ADComputer -LDAPFilter "(OperatingSystemVersion=*18363*)" -SearchBase "OU=Desktop Computers,DC=influentials,DC=local" -properties OperatingSystemVersion | Format-Table Name,OperatingSystemVersion -wrap -auto
     } '8' {
         'You have chosen All Windows Machines'
         Get-ADComputer -LDAPFilter "(OperatingSystemVersion=10.0*)" -SearchBase "OU=Desktop Computers,DC=influentials,DC=local" -properties OperatingSystemVersion | Format-Table Name,OperatingSystemVersion -wrap -auto
     } 'q' {
         return
     }
 }
 pause
 }
 until ($selection -eq 'q')